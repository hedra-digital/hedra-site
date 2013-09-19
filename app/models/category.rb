# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string(255)
#

class Category < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  # Relationships
  has_many                            :books
  has_many                            :categories_publishers
  has_and_belongs_to_many             :publishers
  # Specify fields that can be accessible through mass assignment
  attr_accessible :name, :book_ids, :order, :publisher_ids

  validates :order, :presence => true, :numericality => true
end