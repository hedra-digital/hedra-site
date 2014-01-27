class CreateBookComments < ActiveRecord::Migration
  def change
    create_table :book_comments do |t|
      t.integer :book_id
      t.string :content
      t.string :author
      t.string :vehicle
      t.date :commented_at
      
      t.timestamps
    end
  end
end