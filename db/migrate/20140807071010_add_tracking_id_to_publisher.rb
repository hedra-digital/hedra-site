class AddTrackingIdToPublisher < ActiveRecord::Migration
  def change
  	add_column :publishers, :tracking_id, :string
  end
end
