class AddSlugToPromotion < ActiveRecord::Migration
  def change
  	add_column :promotions, :slug, :string
  end
end
