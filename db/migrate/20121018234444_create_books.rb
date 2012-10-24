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
      t.datetime :released_at
      t.references :binding_type

      t.timestamps
    end
    add_index :books, :binding_type_id
  end
end
