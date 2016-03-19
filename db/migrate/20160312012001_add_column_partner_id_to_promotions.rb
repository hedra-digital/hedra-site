class AddColumnPartnerIdToPromotions < ActiveRecord::Migration
  def change
  	add_column :promotions, :partner_id, :integer
  end
end
