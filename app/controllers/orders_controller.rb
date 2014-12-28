class OrdersController < ApplicationController
	before_filter :authenticate_user!

  def index
  	@orders = Order.joins(:transactions).includes(:order_items)
  	.where("orders.user_id = ? and transactions.status = ?", current_user.id, Transaction::COMPLETED)
  	.order("orders.id desc")
  end
end

