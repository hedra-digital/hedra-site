# -*- encoding : utf-8 -*-
class AddFeatureImageToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :feature_image, :string
  end
end
