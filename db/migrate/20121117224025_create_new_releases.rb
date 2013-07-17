# -*- encoding : utf-8 -*-
class CreateNewReleases < ActiveRecord::Migration
    def change
      create_table :new_releases do |t|
        t.integer :book_id

        t.timestamps
      end
      add_index :new_releases, :book_id
    end
  end
