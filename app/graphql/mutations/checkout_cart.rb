module Mutations
  class CheckoutCart < AuthenticatedMutation
    field :receipt, Types::ReceiptType, null: true
    field :user_errors, [Types::UserError], null: false

    def resolve
      @cart = context[:current_cart]

      errors = validate_and_update_cart
      return { receipt: nil, user_errors: errors } if errors.any?

      receipt = perform_checkout
      @cart.destroy!

      { receipt: receipt, user_errors: [] }
    end

    private

    def perform_checkout
      @cart.cart_items.all.each do |ci|
        ci.product.decrement!(:inventory_count, ci.quantity)
      end

      generate_receipt
    end

    def generate_receipt
      receipt = Receipt.new user: context[:current_user]
      receipt.receipt_items.new(@cart.cart_items.map do |ci|
        {
          quantity: ci.quantity,
          price: ci.price,
          product: ci.product
        }
      end)
      receipt.save!
      receipt
    end

    # Validate product stock availability
    def validate_and_update_cart
      errors = []

      @cart.cart_items.all.each do |ci|
        next unless ci.quantity > ci.product.inventory_count

        if ci.product.inventory_count.zero?
          ci.destroy!
          errors.push(generate_out_of_stock_error(ci))
        else
          ci.update(quantity: ci.product.inventory_count)
          errors.push(generate_exceed_error(ci))
        end
      end

      errors
    end

    def generate_exceed_error(cart_item)
      {
        message: "The qty for #{cart_item.product.title} exceeds availability.
                        The quantity in your cart has been updated.",
        path: ['product', cart_item.product.title]
      }
    end

    def generate_out_of_stock_error(cart_item)
      {
        message: "#{cart_item.product.title} is no longer in stock.
                  It has been removed from your cart.",
        path: ['product', cart_item.product.title]
      }
    end
  end
end
