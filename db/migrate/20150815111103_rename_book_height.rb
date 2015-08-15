class RenameBookHeight < ActiveRecord::Migration
  def up
    rename_column :books, :height, :length
  end

  def down
    rename_column :books, :length, :height
  end
end
