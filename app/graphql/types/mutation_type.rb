module Types
  class MutationType < Types::BaseObject
    field :add_to_cart, mutation: Mutations::AddToCart 
    field :checkout_cart, mutation: Mutations::CheckoutCart 
  end
end
