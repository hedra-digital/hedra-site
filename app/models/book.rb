# == Schema Information
#
# Table name: books
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  pages           :integer
#  isbn            :string(255)
#  description     :text
#  width           :float
#  height          :float
#  weight          :float
#  released_at     :datetime
#  binding_type_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  slug            :string(255)
#

class Book < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, :use => :slugged

  # Relationships
  has_many :participations
  has_many :people, :through => :participations
  has_many :roles, :through => :participations
  has_and_belongs_to_many :languages
  belongs_to :binding_type, :inverse_of => :books
  has_many :features, :inverse_of => :book

  # Allow other models to be nested within this one
  accepts_nested_attributes_for :people, :roles, :participations, :binding_type, :languages

  # Specify fields that can be accessible through mass assignment
  attr_accessible :description, :edition, :height, :title, :pages, :isbn, :released_at, :weight, :width, :binding_type_id, :language_ids, :participations_attributes

  # Validations
  validates_presence_of :title, :isbn, :pages
  validates_uniqueness_of :slug
end
