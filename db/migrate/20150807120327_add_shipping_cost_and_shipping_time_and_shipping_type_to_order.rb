class AddShippingCostAndShippingTimeAndShippingTypeToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :shipping_cost, :decimal, :precision => 8, :scale => 2, :default => 0.0
    add_column :orders, :shipping_time, :integer
    add_column :orders, :shipping_type, :string
  end
end
