# -*- encoding : utf-8 -*-
class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :book
  attr_accessible :price, :quantity, :order_id, :book_id, :book_type

  def sym_attributes
    attributes.symbolize_keys!
  end
end