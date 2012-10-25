# == Schema Information
#
# Table name: features
#
#  id         :integer          not null, primary key
#  book_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Feature < ActiveRecord::Base
  # Relationships
  belongs_to :book, :inverse_of => :features

  # Specify fields that can be accessible through mass assignment
  attr_accessible :book_id
end
