class CreateReceipts < ActiveRecord::Migration[5.2]
  def change
    create_table :receipts do |t|
      t.decimal :total, precision: 12, scale: 3
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
