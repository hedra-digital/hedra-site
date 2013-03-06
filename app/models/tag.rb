# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string(255)
#

class Tag < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  # Relationships
  has_and_belongs_to_many :books
  has_one :page, :dependent => :destroy

  # Specify fields that can be accessible through mass assignment
  attr_accessible :name, :books_attributes, :book_ids

  # Allow other models to be nested within this one
  accepts_nested_attributes_for :books, :allow_destroy => true
end
