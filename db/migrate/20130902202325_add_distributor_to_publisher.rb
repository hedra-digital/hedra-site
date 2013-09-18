class AddDistributorToPublisher < ActiveRecord::Migration
  def change
  	add_column :publishers, :distributors, :text
  end
end
