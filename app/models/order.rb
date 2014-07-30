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
end