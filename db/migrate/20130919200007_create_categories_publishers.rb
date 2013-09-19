class CreateCategoriesPublishers < ActiveRecord::Migration
  def change
    create_table :categories_publishers do |t|
      t.references :category
      t.references :publisher
      t.timestamps
    end
  end
end
