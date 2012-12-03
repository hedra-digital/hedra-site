# == Schema Information
#
# Table name: new_releases
#
#  id         :integer          not null, primary key
#  book_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class NewRelease < ActiveRecord::Base
  # Relationships
  belongs_to                          :book, :inverse_of => :new_releases

  # Specify fields that can be accessible through mass assignment
  attr_accessible                     :book_id
end
