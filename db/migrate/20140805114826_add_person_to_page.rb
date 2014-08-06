class AddPersonToPage < ActiveRecord::Migration
  def change
  	add_column :pages, :person_id, :integer
  end
end
