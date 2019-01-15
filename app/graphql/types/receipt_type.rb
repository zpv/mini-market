module Types
  class ReceiptType < Types::BaseObject
    field :id, ID, null: false

    field :subtotal, Float, null: false
    field :receipt_items, [ReceiptItemType], null: true
  end
end
