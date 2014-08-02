class AddLinkToPromotion < ActiveRecord::Migration
  def change
  	add_column :promotions, :link, :string
  end
end
