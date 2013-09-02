class AddAboutToPublisher < ActiveRecord::Migration
  def change
  	add_column :publishers, :about, :text
  end
end
