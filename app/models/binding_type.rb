class BindingType < ActiveRecord::Base
  # Relationships
  has_and_belongs_to_many :books

  # Specify fields that can be accessible through mass assignment
  attr_accessible :name
end
