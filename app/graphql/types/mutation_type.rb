module Types
  class MutationType < Types::BaseObject
    field :add_to_cart, mutation: Mutations::AddToCart
    field :checkout_cart, mutation: Mutations::CheckoutCart
    field :create_user, mutation: Mutations::CreateUser
    field :sign_in_user, mutation: Mutations::SignInUser
  end
end
