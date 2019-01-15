class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy

  before_save :update_subtotal

  def subtotal
    cart_items.collect { |ci| ci.valid? ? ci.total_price : 0 }.sum
  end

private

  def update_subtotal
    self[:subtotal] = subtotal
  end
end
