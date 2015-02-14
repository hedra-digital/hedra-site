class CreateBusinessPartners < ActiveRecord::Migration
  def change
    create_table :business_partners do |t|
      t.string :tax_id
      t.string :erp_id

      t.timestamps
    end
  end
end
