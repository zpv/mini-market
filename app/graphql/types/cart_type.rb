module Types
  class CartType < Types::BaseObject
    field :id, ID, null: false
    field :subtotal, Float, null: false
    
    field :cart_items, [CartItemType], null: true
  end
end
