class CreateHomePages < ActiveRecord::Migration
  def change
    create_table :home_pages do |t|

      t.timestamps
    end
  end
end
