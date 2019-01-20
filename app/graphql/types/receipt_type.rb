module Types
  class ReceiptType < Types::BaseObject
    description "A record of a user's previous order"

    field :id, ID, null: false

    field :subtotal, Float, null: false
    field :receipt_items, [ReceiptItemType], null: true
  end
end
