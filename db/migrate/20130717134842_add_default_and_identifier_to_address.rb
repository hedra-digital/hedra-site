class AddDefaultAndIdentifierToAddress < ActiveRecord::Migration
  def change
  	add_column :addresses, :default, :boolean
  	add_column :addresses, :identifier, :string
  end
end
