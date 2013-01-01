class Page < ActiveRecord::Base
  attr_accessible :body, :tag_id, :tag_image
  belongs_to :tag
  has_and_belongs_to_many :features

  validates_associated :tag
  validates_uniqueness_of :tag_id

  mount_uploader :tag_image, TagImageUploader
end
