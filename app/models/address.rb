class Address < ActiveRecord::Base
  attr_accessible :address, :city, :complement, :country, :district, :number, :state, :user_id, :zip_code, :default, :identifier, :location_id

  belongs_to :user
  has_many :orders

  STATE = ["AC","AL","AP","AM","BA","CE","DF","ES","GO","MA","MT","MS","MG","PA","PB","PR","PE","PI","RJ","RN","RS","RO","RR","SC","SP","SE","TO"]

  def self.change_user_default(user_id, address_id)
  	addresses = Address.where(:default => true, :user_id => user_id)

  	addresses.each do |address|
  		if address.id != address_id
  			address.default = false
  			address.save
  		end
  	end
  end


  def address_line1
    "#{self.address}, #{self.number}".truncate(60)
  end 


  def address_line2
    "#{self.city}, #{self.state}, #{self.zip_code}"
  end    
end
