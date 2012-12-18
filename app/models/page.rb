class Page < ActiveRecord::Base
  attr_accessible :body, :tag_id
  belongs_to :tag

  validates_associated :tag
  validates_uniqueness_of :tag_id
end
