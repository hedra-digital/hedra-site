class AddPostTrackingCodeToOrder < ActiveRecord::Migration
  def change
  	add_column :orders, :post_tracking_code, :string
  end
end
