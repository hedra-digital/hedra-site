class Role < ActiveRecord::Base
  # Relationships
  has_many :participations

  # Specify fields that can be accessible through mass assignment
  attr_accessible :name
end
