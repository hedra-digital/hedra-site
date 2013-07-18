# -*- encoding : utf-8 -*-
class Order < ActiveRecord::Base
  attr_accessible :item_total, :total, :state, :completed_at, :shipment_state, :payment_state, :email, :special_instructions, :user, :address, :book, :user_id
  belongs_to :user
  has_many :transactions
  has_many :order_items
  belongs_to :address

  def name
    "##{self.id}"
  end

  def self.create_order(transaction, address)
    order = self.create(user_id: transaction.user_id, address: address,
      email: transaction.user.email, payment_state: 'Aguardando aprovação',
      shipment_state: 'Aguardando envio', total: transaction.total)
    transaction.items.each do |item|
      book = Book.find(item[:number])
      OrderItem.create(order_id: order.id, book_id: item[:number], price: book.price_print, quantity: item[:quantity])
    end
    order
  end
end