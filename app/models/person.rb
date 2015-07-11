# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: people
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Person < ActiveRecord::Base
  # Relationships
  has_many :participations, :dependent => :destroy
  has_many :books, :through => :participations
  has_many :roles, :through => :participations

  has_one :site_page, class_name: "Page", dependent: :destroy

  # Specify fields that can be accessible through mass assignment
  attr_accessible :name
end
