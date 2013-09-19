class AddOrderToCategoria < ActiveRecord::Migration
  def change
    add_column :categories, :order, :integer
  end
end
