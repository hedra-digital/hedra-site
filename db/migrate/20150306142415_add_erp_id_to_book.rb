class AddErpIdToBook < ActiveRecord::Migration
  def change
  	add_column :books, :erp_id, :string
  end
end
