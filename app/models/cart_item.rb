class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  before_save :update_prices

  def price
    product.price
  end

  def total_price
    price * quantity
  end

private
  
  def update_prices
    self[:price] = price
    self[:total_price] = quantity * self[:price]
  end
end
