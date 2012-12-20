# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string(255)
#

class Category < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  # Relationships
  has_many :books

  # Specify fields that can be accessible through mass assignment
  attr_accessible :name, :book_ids
end
