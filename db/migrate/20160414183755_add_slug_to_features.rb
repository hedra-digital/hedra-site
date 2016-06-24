class AddSlugToFeatures < ActiveRecord::Migration
  class FeatureMigration < ActiveRecord::Base;
    self.table_name = 'features'
  end

  def up
    add_column :features, :slug, :string
    FeatureMigration.where(slug: nil).find_each do |feature|
      image_name = SecureRandom.hex
      if feature.feature_image.present?
        image_name = File.basename feature.feature_image, '.*'
      end
      feature.slug = image_name.parameterize
      feature.save!
    end
  end

  def down
	remove_column :features, :slug
  end
end
