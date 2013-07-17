class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :order
      t.references :book
      t.float :price
      t.integer :quantity

      t.timestamps
    end
    add_index :order_items, :order_id
    add_index :order_items, :book_id
  end
end
