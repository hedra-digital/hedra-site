# == Schema Information
#
# Table name: participations
#
#  id        :integer          not null, primary key
#  role_id   :integer
#  book_id   :integer
#  person_id :integer
#

class Participation < ActiveRecord::Base
  # Relationships
  belongs_to :book
  belongs_to :person
  belongs_to :role

  # Specify fields that can be accessible through mass assignment
  attr_accessible :book_id, :person_id, :role_id
end
