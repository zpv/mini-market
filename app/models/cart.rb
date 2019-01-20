class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy

  before_save :update_subtotal

  def subtotal
    cart_items.collect { |ci| ci.valid? ? ci.total_price : 0 }.sum
  end

  def find_item(product_id:)
    cart_items.find_by product_id: product_id
  end

  private

  def update_subtotal
    self[:subtotal] = subtotal
  end
end
