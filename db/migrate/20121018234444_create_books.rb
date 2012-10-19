class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.text :description
      t.float :width
      t.float :height
      t.float :weight
      t.integer :edition
      t.datetime :released_at
      t.integer :pages

      t.timestamps
    end
  end
end
