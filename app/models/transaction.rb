# -*- encoding : utf-8 -*-
class Transaction < ActiveRecord::Base
  attr_accessible :user, :order, :user_ip, :paypal_token, :paypal_payer_id, :completed, :paypal_transaction_id, :paypal_payment_date, :paypal_fee_amount, :paypal_pending_reason, :paypal_reason_code, :status, :user_id, :order_id
  attr_accessor :total, :items
  belongs_to :user
  belongs_to :order

  CREATED = 1
  COMPLETED = 2
  FAILED = 3

  scope :completed, where("status = ?", Transaction::COMPLETED)
  scope :failed, where("status = ?", Transaction::FAILED)
  scope :created, where("status = ?", Transaction::CREATED)

  def self.create_transaction(user, cart)
    transaction = self.create(user_id: user.id, status: CREATED)
    transaction.total = 0
    transaction.items = []
    cart.keys.each do |book_id|
      book = Book.find(book_id)
      transaction.total += book.price_print * cart[book_id]
      transaction.items << {name: book.title, number: book.id, amount: (book.price_print.to_f*100).round, quantity: cart[book_id]}
    end
    return transaction
  end

end
