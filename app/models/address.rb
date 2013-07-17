# -*- encoding : utf-8 -*-
class Address < ActiveRecord::Base
  attr_accessible :address, :city, :complement, :country, :district, :number, :state, :user_id, :zip_code, :default, :identifier

  belongs_to :user
  has_many :orders

end
