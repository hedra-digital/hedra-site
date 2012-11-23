class AddPriceToBooks < ActiveRecord::Migration
  def change
    add_column :books, :price_print, :float
    add_column :books, :price_ebook, :float
  end
end
