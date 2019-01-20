module Types
  class CartItemType < Types::BaseObject
    field :quantity, Integer, null: false
    field :price, Float, null: false
    field :total_price, Float, null: false

    field :product, ProductType, null: false
  end
end
