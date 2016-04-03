class AllowPublishersNullForPromotion < ActiveRecord::Migration
  def up
  	change_column :promotions, :publisher_id, :integer, :null => true
  end
  def down
  end
end
