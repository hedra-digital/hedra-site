class AddHeightToBook < ActiveRecord::Migration
  def change
    add_column :books, :height, :float
  end
end
