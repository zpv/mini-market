class ReceiptItem < ApplicationRecord
  belongs_to :product
  belongs_to :receipt

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def total_price
    price * quantity
  end
end
