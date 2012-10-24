class Book < ActiveRecord::Base
  # Relationships
  has_and_belongs_to_many :authors, :class_name => "Person", :association_foreign_key => :author_id
  has_and_belongs_to_many :translators, :class_name => "Person", :association_foreign_key => :translator_id
  has_and_belongs_to_many :organizers, :class_name => "Person", :association_foreign_key => :organizer_id
  has_and_belongs_to_many :editors, :class_name => "Person", :association_foreign_key => :editor_id
  has_and_belongs_to_many :illustrators, :class_name => "Person", :association_foreign_key => :illustrator_id
  has_and_belongs_to_many :languages
  belongs_to :binding_type, :inverse_of => :books

  # Allow authors to be nested within book
  accepts_nested_attributes_for :authors, :translators, :organizers, :editors, :illustrators, :binding_type, :languages

  # Specify fields that can be accessible through mass assignment
  attr_accessible :description, :edition, :height, :title, :pages, :isbn, :released_at, :weight, :width, :author_ids, :binding_type_id
end
