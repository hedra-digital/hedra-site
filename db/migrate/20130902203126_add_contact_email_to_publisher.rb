class AddContactEmailToPublisher < ActiveRecord::Migration
  def change
  	add_column :publishers, :contact_email, :string
  end
end
