class Page < ActiveRecord::Base
  # Relationships
  belongs_to :tag
  has_and_belongs_to_many :features

  # Validations
  validates_associated :tag
  validates_uniqueness_of :tag_id

  # Specify fields that can be accessible through mass assignment
  attr_accessible :body, :tag_id, :tag_image

  # CarrierWave uploaders
  mount_uploader :tag_image, TagImageUploader
end
