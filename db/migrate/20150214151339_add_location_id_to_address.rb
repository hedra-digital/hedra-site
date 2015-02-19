class AddLocationIdToAddress < ActiveRecord::Migration
  def change
  	add_column :addresses, :location_id, :string
  end
end
