module Types
  class CartType < Types::BaseObject
    description 'Holds items a user has added in a session'

    field :subtotal, Float, null: false
    field :cart_items, [CartItemType], null: true
  end
end
