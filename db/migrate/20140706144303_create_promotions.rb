class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.float :discount
      t.decimal :price, :precision => 8, :scale => 2
      t.integer :book_id
      t.integer :tag_id
      t.integer :category_id
      t.integer :publisher_id, :null => false
      t.datetime :started_at, :null => false
      t.datetime :ended_at, :null => false

      t.timestamps
    end
  end
end
