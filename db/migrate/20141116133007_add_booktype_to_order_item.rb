class AddBooktypeToOrderItem < ActiveRecord::Migration
  def change
  	add_column :order_items, :book_type, :string
  end
end
