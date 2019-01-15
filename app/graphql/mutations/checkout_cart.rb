class Mutations::CheckoutCart < Mutations::BaseMutation
  field :receipt, Types::ReceiptType, null: true
  field :user_errors, [Types::UserError], null: false

  def resolve()
    cart = context[:current_cart]
    user_errors = validate_and_update_cart(cart)

    if user_errors.count > 0
      return {
        receipt: nil,
        user_errors: user_errors
      }
    end

    # perform checkout
    cart.cart_items.all.each do |ci|
      ci.product.decrement!(:inventory_count, ci.quantity)
    end

    receipt = generate_receipt(cart)
    receipt.save!

    cart.destroy!

    {
      receipt: receipt,
      user_errors: []
    }
  end

  private

  def generate_receipt (cart)
    receipt = Receipt.new
    receipt.receipt_items.new(cart.cart_items.map{ | ci |
      {
        quantity: ci.quantity,
        price: ci.price,
        product: ci.product
      }
    })
    receipt
  end

  # Validate product stock availability
  def validate_and_update_cart(cart)
    errors = []

    cart.cart_items.all.each do |ci|
      if ci.quantity > ci.product.inventory_count
        message = ""
        path = ["product", ci.product.title]

        if ci.product.inventory_count == 0
          ci.destroy!
          message = "#{ci.product.title} is no longer in stock. It has been removed from your cart."
        else
          ci.update(quantity: ci.product.inventory_count)
          message = "The quantity for #{ci.product.title} exceeds total inventory count. The quantity in your cart has been updated."
        end

        errors.push(
          {
            message: message,
            path: path
          }
        )
      end
    end

    errors
  end
end