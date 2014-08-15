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

  private

  def send_notification
    if self.status_changed?
      Thread.new do
        Hedra::Notificator.new(self.id).send
        ActiveRecord::Base.connection.close
      end
    end
  end
  
  # do not use order status
  def update_order_state
    if self.status_changed?
      self.order.update_attributes(:state => self.status)
    end
  end

end
