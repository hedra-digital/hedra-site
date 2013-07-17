# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: binding_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BindingType < ActiveRecord::Base
  # Relationships
  has_many :books, :inverse_of => :binding_type

  # Specify fields that can be accessible through mass assignment
  attr_accessible :name
end
