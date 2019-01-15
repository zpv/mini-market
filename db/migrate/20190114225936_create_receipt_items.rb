class CreateReceiptItems < ActiveRecord::Migration[5.2]
  def change
    create_table :receipt_items do |t|
      t.references :product, foreign_key: true
      t.references :receipt, foreign_key: true
      t.integer :quantity
      t.decimal :price, precision: 12, scale: 3
      t.decimal :total_price, precision: 12, scale: 3

      t.timestamps
    end
  end
end
