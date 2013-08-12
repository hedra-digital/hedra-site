# -*- encoding : utf-8 -*-
class Transaction < ActiveRecord::Base
  attr_accessible :user, :order, :user_ip, :paypal_token, :paypal_payer_id, :completed, :paypal_transaction_id, :paypal_payment_date, :paypal_fee_amount, :paypal_pending_reason, :paypal_reason_code, :status, :user_id, :order_id, :customer_ip

  belongs_to :user
  belongs_to :order
  after_save :send_notification, :update_order_state

  CREATED = 1
  COMPLETED = 2
  FAILED = 3

  scope :completed, where("status = ?", Transaction::COMPLETED)
  scope :failed, where("status = ?", Transaction::FAILED)
  scope :created, where("status = ?", Transaction::CREATED)

  def self.update_transaction(request, purchase, transaction_id)
    transaction = self.where(:id => transaction_id).last
    if transaction.status == CREATED
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
    end
    transaction
  end

private

  def send_notification
    if self.status_changed?
      # if Rails.env == "production"
        # MailWorker.perform_async(self.id)
      # else
        MailWorker.new.perform(self.id)
      # end
    end
  end

  def update_order_state
    if self.status_changed?
      self.order.update_attributes(:state => self.status)
    end
  end

end
