class BooksPeople < ActiveRecord::Migration
  def change
    create_table :books_people, :id => false do |t|
      t.references :book
      t.references :author
      t.references :translator
      t.references :organizer
      t.references :editor
      t.references :illustrator
    end
    add_index :books_people, [:book_id, :author_id]
    add_index :books_people, [:book_id, :translator_id]
    add_index :books_people, [:book_id, :organizer_id]
    add_index :books_people, [:book_id, :editor_id]
    add_index :books_people, [:book_id, :illustrator_id]
  end
end
