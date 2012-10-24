class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.references :role
      t.references :book
      t.references :person
    end
    add_index :participations, [:role_id, :book_id, :person_id]
  end
end
