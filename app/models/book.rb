class Book < ActiveRecord::Base
  # Relationships
  has_many :participations
  has_many :people, :through => :participations
  has_many :roles, :through => :participations
  has_and_belongs_to_many :languages
  belongs_to :binding_type, :inverse_of => :books

  # Allow other models to be nested within this one
  accepts_nested_attributes_for :people, :roles, :participations, :binding_type, :languages

  # Specify fields that can be accessible through mass assignment
  attr_accessible :description, :edition, :height, :title, :pages, :isbn, :released_at, :weight, :width, :binding_type_id, :language_ids, :participations_attributes
end
