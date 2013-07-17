# -*- encoding : utf-8 -*-
class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :name, :string
  end
end
