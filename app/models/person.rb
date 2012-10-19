class Person < ActiveRecord::Base
  # Relationships
  has_and_belongs_to_many :books, :foreign_key => :author_id
  has_and_belongs_to_many :books, :foreign_key => :translator_id
  has_and_belongs_to_many :books, :foreign_key => :organizer_id
  has_and_belongs_to_many :books, :foreign_key => :editor_id
  has_and_belongs_to_many :books, :foreign_key => :illustrator_id

  # Specify fields that can be accessible through mass assignment
  attr_accessible :name, :book_id
end
