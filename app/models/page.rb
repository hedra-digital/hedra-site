# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  tag_id     :integer
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tag_image  :string(255)
#  hero_image :string(255)
#

class Page < ActiveRecord::Base

  # Relationships
  belongs_to                :tag
  belongs_to                :person
  has_one                   :feature, :dependent => :destroy

  # Validations
  validates_associated      :tag
  validates_uniqueness_of   :tag_id, :allow_blank => true
  validates_associated      :person
  validates_uniqueness_of   :person_id, :allow_blank => true
  validate :validate_tag_and_person

  # Specify fields that can be accessible through mass assignment
  attr_accessible           :body, :tag_id, :person_id, :tag_image, :hero_image

  # CarrierWave uploaders
  mount_uploader            :tag_image, TagImageUploader
  mount_uploader            :hero_image, HeroImageUploader

  private

  def validate_tag_and_person
    self.errors.add(:tag, "Tag and person can not be blank at the same time") if ( !self.tag_id and !self.person_id)
    self.errors.add(:tag, "Tag and person can not be set at the same time") if ( self.tag_id and self.person_id)
  end
end
