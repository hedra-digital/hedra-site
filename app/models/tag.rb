class Tag < ActiveRecord::Base
  attr_accessible :name, :books_attributes, :book_ids
  has_and_belongs_to_many :books

  accepts_nested_attributes_for :books, :allow_destroy => true
end
