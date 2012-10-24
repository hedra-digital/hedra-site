class BindingType < ActiveRecord::Base
  # Relationships
  has_many :books, :inverse_of => :binding_type

  # Specify fields that can be accessible through mass assignment
  attr_accessible :name
end
