class AddSynchronizedToUser < ActiveRecord::Migration
  def change
  	add_column :users, :synchronized, :boolean

  	User.reset_column_information
    User.all.each do |u|
      u.update_attribute(:synchronized, false)
    end

  end
end
