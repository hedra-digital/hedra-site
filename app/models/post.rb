class Post < ActiveRecord::Base
  attr_accessible :author_id, :body, :book_id, :published_at, :title
  belongs_to :author, :class_name => "AdminUser", :foreign_key => "author_id"
  belongs_to :book

  validates :author,       :presence => true
  validates :body,         :presence => true
  validates :title,        :presence => true
  validates :published_at, :presence => true
end
