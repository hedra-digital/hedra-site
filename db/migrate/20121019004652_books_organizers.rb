class BooksOrganizers < ActiveRecord::Migration
  def change
    create_table :books_organizers, :id => false do |t|
      t.references :book
      t.references :organizer
    end
    add_index :books_organizers, [:book_id, :organizer_id]
  end
end
