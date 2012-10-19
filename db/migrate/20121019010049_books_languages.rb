class BooksLanguages < ActiveRecord::Migration
  def change
    create_table :books_languages, :id => false do |t|
      t.references :book
      t.references :language
    end
    add_index :books_languages, [:book_id, :language_id]
  end
end
