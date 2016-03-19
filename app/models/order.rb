class Order < ActiveRecord::Base
  attr_accessible :item_total, :total, :state,
    :completed_at, :shipment_state, :payment_state,
    :email, :special_instructions, :user, :address,
    :book, :user_id, :post_tracking_code,
    :cpf_cnpj, :telephone, :erp_id,
    :shipping_type, :shipping_cost, :shipping_time, :promotion_id

  belongs_to :user
  has_many :transactions
  has_many :order_items
  belongs_to :address
  belongs_to :promotion

  after_save :send_post_tracking_mail

  scope :completed, -> { where('completed_at is not null') }
  
  scope :completed_at_last_week, -> {
    where(
      completed_at: 1.week.ago.beginning_of_week(:sunday)..1.week.ago.end_of_week(:sunday)
    )
  }

  scope :completed_at_current_month, -> {
    where(
      completed_at: Date.today.beginning_of_month..Date.today.end_of_month
    )
  }

  def name
    "##{self.id}"
  end

  def order_items_to_paypal
    items = []
    self.order_items.each do |item|
      book = item.book
      items << {
        name: book.long_title(item.book_type.to_sym),
        number: book.id,
        amount: (item.price*100).round,
        quantity: item.quantity
      }
    end

    if shipping_cost && shipping_time && shipping_type
      items << {
        name: "Shipping cost(service: #{shipping_type}, cep: #{address.zip_code})",
        number: 0,
        amount: (shipping_cost*100).round,
        quantity: 1
      }
    end

    items
  end

  def order_items_to_iugu
    items = []
    self.order_items.each do |item|
      book = item.book
      items << {description: book.long_title(item.book_type.to_sym), price_cents: (item.price*100).round, quantity: item.quantity}
    end

    if shipping_cost && shipping_time && shipping_type
      items << { description: "Shipping cost(service: #{shipping_type}, cep: #{address.zip_code})", price_cents: (shipping_cost*100).round, quantity: 1 }
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