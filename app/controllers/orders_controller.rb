class OrdersController < ApplicationController
	before_filter :authenticate_user!

  def index
  	@orders = Order.joins(:transactions).includes(:order_items)
  	.where("orders.user_id = ? and transactions.status = ?", current_user.id, Transaction::COMPLETED)
  	.order("orders.id desc")

    # bank slip will be timeout for 3 days
  	unpay_bank_slip = Order.joins(:transactions).includes(:order_items)
  	.where("orders.user_id = ? and transactions.status = ? and transactions.payment_method = ? and transactions.payment_status = ? and transactions.created_at > ?", current_user.id, Transaction::CREATED, Transaction::BANK_SLIP, Transaction::PENDING, 3.days.ago)
  	.order("orders.id desc")

    @orders = unpay_bank_slip + @orders  

  end
end
