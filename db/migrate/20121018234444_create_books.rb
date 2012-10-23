class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.integer :pages
      t.string :isbn
      t.text :description
      t.float :width
      t.float :height
      t.float :weight
      t.integer :edition
      t.datetime :released_at

      t.timestamps
    end
  end
end
