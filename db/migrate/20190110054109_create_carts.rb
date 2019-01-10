class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
      t.decimal :subtotal, precision: 12, scale: 3
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
