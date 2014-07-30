class CheckoutController < ApplicationController

  include ActiveMerchant::Billing
  include CheckoutHelper

  layout "application"

  before_filter :assigns_gateway

  def finish
    @address = Address.find(session[:address_id])
    @order = create_order(current_user, @address, session[:carrinho])
    if !@order.nil?
      session[:transaction_id] = @order.transactions.last.id
      session[:items] = @order.order_items_to_paypal
      session[:order_id] = @order.id
      total_as_cents, setup_purchase_params = get_setup_purchase_params @order, request, @order.order_items_to_paypal
      setup_response = @gateway.setup_purchase(total_as_cents, setup_purchase_params)
      session[:carrinho] = nil
      redirect_to @gateway.redirect_url_for(setup_response.token)
    else
      redirect_to cart_url, :alert => "Não foi possível finalizar a sua compra, pois não há itens no seu carrinho de compras."
    end
  end

  def review
    if params[:token].nil? or params[:PayerID].nil?
      redirect_to cart_url, :notice => "Nos desculpe, ocorreu uma falha ao completar o pagamento pelo PayPal, por favor realize novamente a sua compra."
      return
    end
    total_as_cents, purchase_params = get_purchase_params Order.find(session[:order_id]), request, session[:items], params
    @purchase = @gateway.purchase total_as_cents, purchase_params
    @transaction = Transaction.update_transaction(request, @purchase, session[:transaction_id])
  end

  def assigns_gateway
    hash = {
      :login => APP_CONFIG["paypal_login"],
      :password => APP_CONFIG["paypal_password"],
      :signature => APP_CONFIG["paypal_api_signature"]
    }
    @gateway ||= PaypalExpressGateway.new(
      :login => hash[:login],
      :password => hash[:password],
      :signature => hash[:signature]
    )
  end

  private

  def create_order(user, address, cart)
    return nil if cart.nil?
    order = Order.create(user_id: user.id, address: address,
      email: user.email, payment_state: 'Aguardando aprovação',
      shipment_state: 'Aguardando envio')
    total = 0
    cart.keys.each do |book_id|
      book = Book.find(book_id)
      total += view_context.show_price(book) * cart[book_id]
      OrderItem.create(order_id: order.id, book_id: book_id, price: view_context.show_price(book), quantity: cart[book_id])
    end
    Transaction.create(user_id: order.user_id, status: Transaction::CREATED, :order_id => order.id)
    order.update_attributes(:total => total)
    order
  end


end
