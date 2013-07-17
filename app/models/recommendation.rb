# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: recommendations
#
#  id         :integer          not null, primary key
#  book_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Recommendation < ActiveRecord::Base
  # Relationships
  belongs_to                          :book, :inverse_of => :recommendations

  # Specify fields that can be accessible through mass assignment
  attr_accessible                     :book_id
end
