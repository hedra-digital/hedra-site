class AddMessageToPublisher < ActiveRecord::Migration
  def change
    add_column :publishers, :home_page_message, :string
  end
end
