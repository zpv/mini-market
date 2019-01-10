class Mutations::AddToCart < Mutations::BaseMutation
  argument :product_id, ID, required: true
  argument :quantity, Integer, required: false, default_value: 1

  type Types::CartType

  def resolve(product_id:, quantity:)
    cart = context[:current_cart]

    CartItem.create!(
      product: Product.find_by(id: product_id),
      cart: cart,
      quantity: quantity
    )
    return cart
  end
end