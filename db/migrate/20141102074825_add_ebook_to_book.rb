class AddEbookToBook < ActiveRecord::Migration
  def change
  	add_column :books, :ebook, :string
  	add_column :books, :packet_discount, :float
  end
end
