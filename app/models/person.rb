class Person < ActiveRecord::Base
  # Relationships
  has_many :participations
  has_many :books, :through => :participations

  # Specify fields that can be accessible through mass assignment
  attr_accessible :name
end
