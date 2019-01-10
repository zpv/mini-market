class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items

  before_save :update_subtotal

  def subtotal
    cart_items.collect { |ci| ci.valid? ? (ci.quantity * ci.price) : 0 }.sum
  end

private

  def update_subtotal
    self[:subtotal] = subtotal
  end
end
