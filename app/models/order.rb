class Order < ActiveRecord::Base
  attr_accessible :item_total, :total, :state, :completed_at, :shipment_state, :payment_state, :email, :special_instructions, :user, :address, :book

end
