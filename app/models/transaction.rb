class Transaction < ActiveRecord::Base
  attr_accessible :user, :order, :user_ip, :paypal_token, :paypal_payer_id, :completed, :paypal_transaction_id, :paypal_payment_date, :paypal_fee_amount, :paypal_pending_reason, :paypal_reason_code, :status, :user_id, :order_id
  belongs_to :user
  belongs_to :order

  CREATED = 1
  COMPLETED = 2
  FAILED = 3

  scope :completed, where("status = ?", Transaction::COMPLETED)
  scope :failed, where("status = ?", Transaction::FAILED)
  scope :created, where("status = ?", Transaction::CREATED)
end
