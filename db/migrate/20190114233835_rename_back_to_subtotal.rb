class RenameBackToSubtotal < ActiveRecord::Migration[5.2]
  def change
    rename_column :carts, :total, :subtotal
    rename_column :receipts, :total, :subtotal
  end
end
