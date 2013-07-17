# -*- encoding : utf-8 -*-
class AddCoverToBooks < ActiveRecord::Migration
  def change
    add_column :books, :cover, :string
  end
end
