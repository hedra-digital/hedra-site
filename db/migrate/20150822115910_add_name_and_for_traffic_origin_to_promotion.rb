class AddNameAndForTrafficOriginToPromotion < ActiveRecord::Migration
  def change
    add_column :promotions, :name, :string
    add_column :promotions, :for_traffic_origin, :boolean, default: false
  end
end
