# -*- encoding : utf-8 -*-
class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.integer :book_id

      t.timestamps
    end
    add_index :features, :book_id
  end
end
