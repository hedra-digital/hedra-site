class Participation < ActiveRecord::Base
  # Relationships
  belongs_to :book
  belongs_to :person
  belongs_to :role

  # Specify fields that can be accessible through mass assignment
  attr_accessible :book_id, :person_id, :role_id
end
