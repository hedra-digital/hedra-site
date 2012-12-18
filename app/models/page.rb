class Page < ActiveRecord::Base
  attr_accessible :body, :tag_id
  belongs_to :tag
end
