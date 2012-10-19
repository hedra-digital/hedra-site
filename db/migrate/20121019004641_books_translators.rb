class BooksTranslators < ActiveRecord::Migration
  def change
    create_table :books_translators, :id => false do |t|
      t.references :book
      t.references :translator
    end
    add_index :books_translators, [:book_id, :translator_id]
  end
end
