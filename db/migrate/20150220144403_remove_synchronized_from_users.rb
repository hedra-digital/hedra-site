class RemoveSynchronizedFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :synchronized
  end

  def down
    add_column :users, :synchronized, :boolean
  end
end
