class AddTotalPriceOrderitem < ActiveRecord::Migration[5.2]
  def change
    change_table :cart_items do |t|
      t.decimal :price, precision: 12, scale: 3
      t.decimal :total_price, precision: 12, scale: 3
    end
  end
end
