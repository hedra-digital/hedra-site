class ChangePositionColumn < ActiveRecord::Migration
  def up
    change_column :books, :position, :integer, :default => 5

    Book.reset_column_information
    Book.all.each do |b|
      b.update_attribute(:position, 5) unless b.position
    end
  end

  def down
  end
end
