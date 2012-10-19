class AuthorsBooks < ActiveRecord::Migration
  def change
    create_table :authors_books, :id => false do |t|
      t.references :author
      t.references :book
    end
    add_index :authors_books, [:author_id, :book_id]
  end
end
