# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: publishers
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  url             :string(255)
#  logo            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Publisher < ActiveRecord::Base
  
  has_many :books

  attr_accessible 					  :name, :url, :logo, :about, :distributors, :contact_email, :contact

  mount_uploader                      :logo, LogoUploader

end
