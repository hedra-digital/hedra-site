class Person < ActiveRecord::Base
  # Relationships
  has_and_belongs_to_many :books, :source => :authors, :foreign_key => :author_id
  has_and_belongs_to_many :books, :source => :translators, :foreign_key => :translator_id
  has_and_belongs_to_many :books, :source => :organizers, :foreign_key => :organizer_id
  has_and_belongs_to_many :books, :source => :editors, :foreign_key => :editor_id
  has_and_belongs_to_many :books, :source => :illustrators, :foreign_key => :illustrator_id

  # Specify fields that can be accessible through mass assignment
  attr_accessible :name
end
