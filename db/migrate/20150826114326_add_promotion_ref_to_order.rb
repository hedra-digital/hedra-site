class AddPromotionRefToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :promotion_id, :integer
    add_index :orders, :promotion_id
  end
end
