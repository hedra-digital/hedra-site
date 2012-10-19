class BooksIllustrators < ActiveRecord::Migration
  def change
    create_table :books_illustrators, :id => false do |t|
      t.references :book
      t.references :illustrator
    end
    add_index :books_illustrators, [:book_id, :illustrator_id]
  end
end
