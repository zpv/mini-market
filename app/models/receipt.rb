class Receipt < ApplicationRecord
  belongs_to :user, optional: true
  has_many :receipt_items, dependent: :destroy

  before_save :update_subtotal

  def subtotal
    receipt_items.collect { |ri| ri.valid? ? ri.total_price : 0 }.sum
  end

  private

  def update_subtotal
    self[:subtotal] = subtotal
  end
end
