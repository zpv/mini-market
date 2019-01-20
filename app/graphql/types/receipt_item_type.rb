module Types
  class ReceiptItemType < Types::BaseObject
    description 'Represents a purchased item as part of a receipt'

    field :quantity, Integer, null: false
    field :price, Float, null: false
    field :total_price, Float, null: false

    field :product, ProductType, null: false
  end
end
