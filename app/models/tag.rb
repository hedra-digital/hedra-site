class Tag < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  # Relationships
  has_and_belongs_to_many :books
  has_one :page

  # Specify fields that can be accessible through mass assignment
  attr_accessible :name, :books_attributes, :book_ids

  # Allow other models to be nested within this one
  accepts_nested_attributes_for :books, :allow_destroy => true
end
