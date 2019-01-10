module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    field :add_to_cart, mutation: Mutations::AddToCart 
  end
end
