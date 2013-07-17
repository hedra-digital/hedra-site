# -*- encoding : utf-8 -*-
class AddCategoryIdToBooks < ActiveRecord::Migration
  def change
    add_column :books, :category_id, :integer
  end
end
