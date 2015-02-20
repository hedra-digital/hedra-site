class AddErpIdToOrder < ActiveRecord::Migration
  def change
  	add_column :orders, :erp_id, :string
  end
end
