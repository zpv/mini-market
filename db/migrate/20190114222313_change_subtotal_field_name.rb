class ChangeSubtotalFieldName < ActiveRecord::Migration[5.2]
  def change
    rename_column :carts, :subtotal, :total
  end
end
