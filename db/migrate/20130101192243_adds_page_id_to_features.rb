class AddsPageIdToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :page_id, :integer
  end
end
