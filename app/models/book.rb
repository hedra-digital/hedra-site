# -*- encoding : utf-8 -*-
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
#  released_at     :date
#  binding_type_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  slug            :string(255)
#  cover           :string(255)
#  price_print     :float
#  price_ebook     :float
#  category_id     :integer
#  publisher_id    :integer
#

class Book < ActiveRecord::Base
  extend FriendlyId
  friendly_id                         :title, :use => :slugged

  # Callbacks
  before_save                         :sanitize_description

  # Relationships
  has_many                            :participations, :dependent => :destroy
  has_many                            :people, :through => :participations
  has_many                            :roles, :through => :participations
  has_and_belongs_to_many             :languages
  has_and_belongs_to_many             :tags
  belongs_to                          :binding_type, :inverse_of => :books
  has_many                            :features, :inverse_of => :book, :dependent => :destroy
  has_many                            :new_releases, :inverse_of => :book, :dependent => :destroy
  has_many                            :recommendations, :inverse_of => :book, :dependent => :destroy
  belongs_to                          :category
  has_many                            :order_items
  belongs_to                          :publisher
  has_many                            :book_comments

  # Allow other models to be nested within this one
  accepts_nested_attributes_for       :participations, :allow_destroy => true
  accepts_nested_attributes_for       :binding_type, :languages
  accepts_nested_attributes_for       :tags, :allow_destroy => true

  # Specify fields that can be accessible through mass assignment
  attr_accessible                     :description, :edition, :height, :title, :pages, :isbn, :released_at, :weight, :width, :binding_type_id, :language_ids, :participations_attributes, :cover, :price_print, :price_ebook, :category_id, :tags_attributes, :tag_ids, :publisher_id

  # Validations
  validates_presence_of               :title, :isbn, :pages
  validates_uniqueness_of             :slug
  validates                           :publisher, :presence => true

  # CarrierWave uploader
  mount_uploader                      :cover, CoverUploader

  # Search
  define_index do
    indexes title
    indexes isbn
    indexes description
    indexes people(:name), :as => :people
  end


  def dimensions
    "#{self.width} &times; #{self.height} cm".html_safe if self.width.present? && self.height.present?
  end

  def language_list
    formatted_list(self.languages.map { |x| x.name.downcase }) if self.languages.count > 1
  end

  def weight_with_unit
    self.weight.to_s + " kg"
  end

  def binding_name
    self.binding_type.name if binding_type.present?
  end

  def release_year
    self.released_at.year if released_at.present?
  end

  def has_price?
    self.price_print.present? || self.price_ebook.present?
  end

  private

  def formatted_list(array)
    array.to_sentence(:two_words_connector => ' e ', :last_word_connector => ' e ').capitalize
  end

  def sanitize_description
    self.description = Sanitize.clean(self.description, Sanitize::Config::BASIC).html_safe
  end

end
