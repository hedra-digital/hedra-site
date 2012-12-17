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
  attr_accessible :name

  extend FriendlyId
  friendly_id :name, :use => :slugged

  has_many :books
end
