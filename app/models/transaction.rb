class Transaction < ActiveRecord::Base
  attr_accessible :user, :order, :user_ip, :paypal_token, :paypal_payer_id, :completed, :paypal_transaction_id, :paypal_payment_date, :paypal_fee_amount, :paypal_pending_reason, :paypal_reason_code, :status, :user_id, :order_id, :customer_ip, :payment_method, :payment_status

  belongs_to :user
  belongs_to :order
  after_save :send_notification, :update_order_state, :send_ebook

  CREATED = 1
  COMPLETED = 2
  FAILED = 3

  # payment method
  PAYPAL = "paypal"
  BANK_SLIP = "bank_slip"
  CREDIT_CARD = "credit_card"

  # payment status
  PENDING = "pending"
  PAID = "paid"
  CANCELED = "canceled"
  PAYMENT_IN_PROGRESS = "payment_in_progress"
  EXPIRED = "expired"

  scope :completed, where("status = ?", Transaction::COMPLETED)
  scope :failed, where("status = ?", Transaction::FAILED)
  scope :created, where("status = ?", Transaction::CREATED)

  def show_status
    case self.status
      when Transaction::CREATED
        "CREATED"
      when Transaction::COMPLETED
        "COMPLETED"
      when Transaction::FAILED
        "FAILED"
      else
        ""
      end
  end

  private

  # run background job
  # https://www.agileplannerapp.com/blog/building-agile-planner/rails-background-jobs-in-threads
  def background(&block)
    Thread.new do
      yield
      ActiveRecord::Base.connection.close
    end
  end


  def send_notification
    if self.status_changed? and self.status == Transaction::COMPLETED and Rails.env.production?
      Thread.new do
        Notifier.mail_to_trello(self.order).deliver
        ActiveRecord::Base.connection.close
      end
    end
    
    if self.status_changed?
      case self.status
      when Transaction::CREATED
        background {Notifier.order_created(self.order).deliver}
      when Transaction::COMPLETED
        background {Notifier.order_completed(self.order).deliver}
      when Transaction::FAILED
        background {Notifier.order_failed(self.order).deliver}
      end
    end
  end


  def send_ebook
    if self.status_changed? and self.status == Transaction::COMPLETED and self.order.order_items.any?{|i| i.book_type == 'ebook' or i.book_type == 'packet'}
      Thread.new do
        Notifier.send_ebook(self.order).deliver
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
