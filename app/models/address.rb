class Address < ActiveRecord::Base
  attr_accessible :address, :city, :complement, :country, :district, :number, :state, :user_id, :zip_code

  has_one :user



end
