class CreateFeaturesPublishers < ActiveRecord::Migration
  def change
    create_table :features_publishers do |t|
      t.references :feature
      t.references :publisher
      t.timestamps
    end
  end
end
