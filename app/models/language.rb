# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Language < ActiveRecord::Base
  #Relationships
  has_and_belongs_to_many :books

  # Specify fields that can be accessible through mass assignment
  attr_accessible :name
end
