# -*- encoding : utf-8 -*-
class ChangeReleasedAtToDate < ActiveRecord::Migration
  def up
    change_column :books, :released_at, :date
  end

  def down
    change_column :books, :released_at, :datetime
  end
end
