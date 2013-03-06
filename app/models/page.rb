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
  has_one                   :feature, :dependent => :destroy

  # Validations
  validates_associated      :tag
  validates_uniqueness_of   :tag_id

  # Specify fields that can be accessible through mass assignment
  attr_accessible           :body, :tag_id, :tag_image, :hero_image

  # CarrierWave uploaders
  mount_uploader            :tag_image, TagImageUploader
  mount_uploader            :hero_image, HeroImageUploader
end
