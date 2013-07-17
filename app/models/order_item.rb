class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :book
  attr_accessible :price, :quantity, :order_id, :book_id
end
