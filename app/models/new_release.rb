class NewRelease < ActiveRecord::Base
  # Relationships
  belongs_to                          :book, :inverse_of => :new_releases

  # Specify fields that can be accessible through mass assignment
  attr_accessible                     :book_id
end
