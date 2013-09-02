class AddContactToPublisher < ActiveRecord::Migration
  def change
  	add_column :publishers, :contact, :string
  end
end
