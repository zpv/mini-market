class Mutations::AddToCart < Mutations::BaseMutation
  argument :product_id, ID, required: true
  argument :quantity, Integer, required: false, default_value: 1
  
  field :cart, Types::CartType, null: false
  field :user_errors, [Types::UserError], null: false

  def resolve(product_id:, quantity:)
    cart = context[:current_cart]
    product = Product.find_by(id: product_id)

    cart_item = cart.cart_items.find_by product_id: product_id

    # Inventory available actually available given products already in cart
    real_inventory_count = cart_item.nil? ? product.inventory_count : product.inventory_count - cart_item.quantity

    if real_inventory_count < quantity
      # Return original cart with insufficient stock error
      return {
        cart: cart,
        user_errors: [{
          message: "Unable to add to cart: Insufficient product stock.",
          path: ["product", product.title]
        }]
      }
    end

    # If cart item with product already exists, just update its quantity.
    # Otherwise, create a new cart item.
    if !cart_item.nil?
      cart_item.increment!(:quantity, quantity)
    else
      cart.cart_items.new(
        product: Product.find_by(id: product_id),
        cart: cart,
        quantity: quantity
      )
    end

    cart.save
    context[:session][:cart_id] = cart.id

    return {
      cart: cart,
      user_errors: []
    }
  end
end