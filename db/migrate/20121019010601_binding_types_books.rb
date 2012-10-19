class BindingTypesBooks < ActiveRecord::Migration
  def change
    create_table :binding_types_books, :id => false do |t|
      t.references :binding_type
      t.references :books
    end
    add_index :binding_types_books, [:binding_type_id, :book_id]
  end
end
