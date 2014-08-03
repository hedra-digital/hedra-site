class AddTitleToPublisher < ActiveRecord::Migration
  def change
  	add_column :publishers, :about_label, :string
  	add_column :publishers, :about_title, :string
  end
end
