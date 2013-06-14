class AddExterNalSiteUrlToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :external_site_url, :string
  end
end
