# -*- encoding : utf-8 -*-
class CreateRecommendations < ActiveRecord::Migration
    def change
      create_table :recommendations do |t|
        t.integer :book_id

        t.timestamps
      end
      add_index :recommendations, :book_id
    end
  end
