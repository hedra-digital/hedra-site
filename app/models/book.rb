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
#  cover           :string(255)
#

class Book < ActiveRecord::Base
  extend FriendlyId
  friendly_id                         :title, :use => :slugged

  # Relationships
  has_many                            :participations
  has_many                            :people, :through => :participations
  has_many                            :roles, :through => :participations
  has_and_belongs_to_many             :languages
  belongs_to                          :binding_type, :inverse_of => :books
  has_many                            :features, :inverse_of => :book
  has_many                            :new_releases, :inverse_of => :book
  has_many                            :recommendations, :inverse_of => :book

  # Allow other models to be nested within this one
  accepts_nested_attributes_for       :participations, :allow_destroy => true
  accepts_nested_attributes_for       :binding_type, :languages

  # Specify fields that can be accessible through mass assignment
  attr_accessible                     :description, :edition, :height, :title, :pages, :isbn, :released_at, :weight, :width, :binding_type_id, :language_ids, :participations_attributes, :cover

  # Validations
  validates_presence_of               :title, :isbn, :pages
  validates_uniqueness_of             :slug

  # CarrierWave uploader
  mount_uploader                      :cover, CoverUploader

  def dimensions
    "#{self.width} &times; #{self.height} cm".html_safe if self.width.present? && self.height.present?
  end

  def language_list
    formatted_list(self.languages.map { |x| x.name.downcase }) if self.languages.count > 1
  end

  def binding_name
    self.binding_type.name if binding_type.present?
  end

  def release_year
    self.released_at.year if released_at.present?
  end

  private

  def formatted_list(array)
    array.to_sentence(:two_words_connector => ' e ', :last_word_connector => ' e ').capitalize
  end

end
