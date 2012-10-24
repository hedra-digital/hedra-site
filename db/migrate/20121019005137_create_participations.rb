class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.references :role
      t.references :book
      t.references :person
    end
    add_index :participations, :role_id
    add_index :participations, :book_id
    add_index :participations, :person_id
  end
end
