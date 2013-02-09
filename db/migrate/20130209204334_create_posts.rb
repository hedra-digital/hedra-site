class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.date :published_at
      t.integer :book_id
      t.integer :author_id

      t.timestamps
    end
  end
end
