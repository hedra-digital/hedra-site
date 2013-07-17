# -*- encoding : utf-8 -*-
class AddZipCodeToAddress < ActiveRecord::Migration
  def change
  	add_column :addresses, :zip_code, :string
  end
end
