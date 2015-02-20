class CreateBusinessPartnerLocations < ActiveRecord::Migration
  def change
    create_table :business_partner_locations do |t|
      t.integer :business_partner_id
      t.integer :address_id
      t.string :erp_id

      t.timestamps
    end

    add_index :business_partner_locations, [:business_partner_id, :address_id], :unique => true, :name => 'index_business_partner_locations_unique'
  end
end
