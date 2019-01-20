module Types
  class CartItemType < Types::BaseObject
    description "Represents an item in a cart, with information such as quantity added"

    field :quantity, Integer, null: false
    field :price, Float, null: false
    field :total_price, Float, null: false

    field :product, ProductType, null: false
  end
end
