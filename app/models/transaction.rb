# -*- encoding : utf-8 -*-
class Transaction < ActiveRecord::Base
  attr_accessible :user, :order, :user_ip, :paypal_token, :paypal_payer_id, :completed, :paypal_transaction_id, :paypal_payment_date, :paypal_fee_amount, :paypal_pending_reason, :paypal_reason_code, :status, :user_id, :order_id, :customer_ip
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
    end
    return transaction
  end

  def self.update_transaction(request, purchase, transaction_id)
    transaction = self.where(:id => transaction_id).last
    transaction.update_attributes(
      :customer_ip => request.ip,
      :paypal_fee_amount => purchase.params['fee_amount'],
      :paypal_payer_id => purchase.payer_id,
      :paypal_payment_date => purchase.params['payment_date'],
      :paypal_pending_reason => purchase.params['pending_reason'],
      :paypal_reason_code => purchase.params['reason_code'],
      :paypal_token => purchase.token,
      :paypal_transaction_id => purchase.params['transaction_id'],
      :completed => purchase.success?,
      :status => (purchase.success? == true)? COMPLETED : FAILED
      )
    transaction
  end

end
