module Types
  class ProductType < Types::BaseObject
    description 'An item that is purchasable by a user'

    field :id, ID, null: false

    field :title, String, null: false
    field :price, Float, null: false
    field :inventory_count, Integer, null: false
  end
end
