class RemoveCartUserReference < ActiveRecord::Migration[5.2]
  def change
    remove_column :carts, :user
  end
end
