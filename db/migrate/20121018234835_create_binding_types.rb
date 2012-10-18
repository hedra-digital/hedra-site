class CreateBindingTypes < ActiveRecord::Migration
  def change
    create_table :binding_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
