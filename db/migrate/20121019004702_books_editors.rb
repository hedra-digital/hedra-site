class BooksEditors < ActiveRecord::Migration
  def change
    create_table :books_editors, :id => false do |t|
      t.references :book
      t.references :editor
    end
    add_index :books_editors, [:book_id, :editor_id]
  end
end
