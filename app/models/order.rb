# -*- encoding : utf-8 -*-
class Order < ActiveRecord::Base
  attr_accessible :item_total, :total, :state, :completed_at, :shipment_state, :payment_state, :email, :special_instructions, :user, :address, :book, :user_id
  belongs_to :user
  has_many :transactions
  has_many :order_items
  belongs_to :address

  after_create :create_transaction

  def name
    "##{self.id}"
  end

  def self.create_order(user, address, cart)
    order = self.create(user_id: user.id, address: address,
      email: user.email, payment_state: 'Aguardando aprovação',
      shipment_state: 'Aguardando envio')
    total = 0
    cart.keys.each do |book_id|
      book = Book.find(book_id)
      total += book.price_print * cart[book_id]
      OrderItem.create(order_id: order.id, book_id: book_id, price: book.price_print, quantity: cart[book_id])
    end
    order.update_attributes(:total => total)
    order
  end

  def order_items_to_paypal
    items = []
    self.order_items.each do |item|
      book = item.book
      items << {name: book.title, number: book.id, amount: (item.price*100).round, quantity: item.quantity}
    end
    items
  end

  def state_to_s
    case self.state
    when Transaction::CREATED
      "aguardando pagamento"
    when Transaction::COMPLETED
      "pagamento realizado"
    when Transaction::FAILED
      "falha no pagamento"
    end
  end

private

  def create_transaction
    Transaction.create(user_id: self.user_id, status: Transaction::CREATED, :order_id => self.id)
  end
end