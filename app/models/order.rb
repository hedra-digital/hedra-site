class Order < ActiveRecord::Base
  attr_accessible :item_total, :total, :state, :completed_at, :shipment_state, :payment_state, :email, :special_instructions, :user, :address, :book, :user_id, :post_tracking_code
  belongs_to :user
  has_many :transactions
  has_many :order_items
  belongs_to :address

  after_save :send_post_tracking_mail

  def name
    "##{self.id}"
  end

  def order_items_to_paypal
    items = []
    self.order_items.each do |item|
      book = item.book
      items << {name: book.long_title(item.book_type.to_sym), number: book.id, amount: (item.price*100).round, quantity: item.quantity}
    end
    items
  end

  def order_items_to_iugu
    items = []
    self.order_items.each do |item|
      book = item.book
      items << {description: book.long_title(item.book_type.to_sym), price_cents: (item.price*100).round, quantity: item.quantity}
    end
    items
  end
  
  # do not use this method
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

  def send_post_tracking_mail
    if self.post_tracking_code_changed? and !self.post_tracking_code.blank?
      Notifier.order_post_tracking(self).deliver
    end
  end
end