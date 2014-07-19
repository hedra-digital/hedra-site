class AddLinkToPublishers < ActiveRecord::Migration
  def change
    add_column :publishers, :link_url, :string
    add_column :publishers, :link_name, :string
  end
end
