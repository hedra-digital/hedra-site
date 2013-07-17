# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: posts
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  body         :text
#  published_at :date
#  book_id      :integer
#  author_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  slug         :string(255)
#

class Post < ActiveRecord::Base
  extend FriendlyId
  friendly_id                         :title, :use => :slugged

  # Relationships
  belongs_to                          :author, :class_name => "AdminUser", :foreign_key => "author_id"
  belongs_to                          :book

  # Validations
  validates :author,                  :presence => true
  validates :body,                    :presence => true
  validates :title,                   :presence => true
  validates :published_at,            :presence => true
  validates :slug,                    :uniqueness => true

  # Specify fields that can be accessible through mass assignment
  attr_accessible                     :author_id, :body, :book_id, :published_at, :title
end
