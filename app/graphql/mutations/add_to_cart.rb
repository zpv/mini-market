module Mutations
  class AddToCart < BaseMutation
    description "Adds a specified number of items to the session's cart."

    argument :product_id, ID, required: true, description: 'Product to be added'
    argument :quantity, Integer, required: false, default_value: 1, description: 'Quantity to add'

    field :cart, Types::CartType, null: false
    field :user_errors, [Types::UserError], null: false

    def resolve(product_id:, quantity:)
      @cart = context[:current_cart]

      product = Product.find_by(id: product_id)

      return product_not_found unless product
      return invalid_quantity unless quantity > 0

      products_left = calc_available_qty(product)

      return insufficient_stock(product) if products_left < quantity

      add_to_cart(product, quantity)

      @cart.save
      context[:session][:cart_id] = @cart.id

      {
        cart: @cart.reload,
        user_errors: []
      }
    end

    private

    # Gets available qty based on how many are already in user's cart
    def calc_available_qty(product)
      cart_item = @cart.find_item product_id: product.id
      product.inventory_count - (cart_item&.quantity || 0)
    end

    # Creates new CartItem if does not exist, otherwise, increment existing one
    def add_to_cart(product, quantity)
      cart_item = @cart.find_item product_id: product.id

      if cart_item.present?
        cart_item.increment!(:quantity, quantity)
      else
        @cart.cart_items.new(
          product: product,
          cart: @cart,
          quantity: quantity
        )
      end
    end

    # Return original cart with insufficient stock error
    def insufficient_stock(product)
      {
        cart: @cart,
        user_errors: [{
          message: 'Unable to add to cart: Insufficient product stock.',
          path: ['product', product.title]
        }]
      }
    end

    def product_not_found
      {
        cart: @cart,
        user_errors: [{
          message: 'Given product was not found',
          path: []
        }]
      }
    end

    def invalid_quantity
      {
        cart: @cart,
        user_errors: [{
          message: 'Quantity must be non-negative',
          path: []
        }]
      }
    end
  end
end
