class Feature < ActiveRecord::Base
  # Relationships
  belongs_to                          :book, :inverse_of => :features

  # Specify fields that can be accessible through mass assignment
  attr_accessible                     :book_id
end
