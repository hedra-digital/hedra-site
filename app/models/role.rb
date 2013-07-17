# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Role < ActiveRecord::Base
  # Relationships
  has_many :participations
  has_many :books, :through => :participations
  has_many :people, :through => :participations

  # Specify fields that can be accessible through mass assignment
  attr_accessible :name
end
