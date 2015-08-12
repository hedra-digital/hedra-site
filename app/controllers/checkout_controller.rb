class CheckoutController < ApplicationController

  include ActiveMerchant::Billing

  layout "application"

  before_filter :assigns_gateway

  def finish
    if session[:cart].blank?
      redirect_to "/", :alert => "Não foi possível finalizar a sua compra, pois não há itens no seu carrinho de compras."
      return
    end

    if !current_user
      redirect_to cart_url, :alert => "Por favor, autentique-se primeiro."
      return
    end

    @order = nil


    if params[:address].blank? || params[:address][:zip_code].blank?
      redirect_to cart_url, :alert => "Por favor, verifique su endereço para a entrega." and return
    end

    begin
      @order = create_order(current_user, params[:address], session[:cart], Transaction::PAYPAL, params[:cpf_cnpj], params[:telephone], params[:shipping_type])
    rescue ArgumentError => e
      redirect_to cart_url, :alert => "Erro AO calcular custo do frete." and return
    end

    if !@order.nil?
      session[:transaction_id] = @order.transactions.last.id
      session[:items] = @order.order_items_to_paypal
      session[:order_id] = @order.id
      total_as_cents, setup_purchase_params = get_setup_purchase_params @order, request, @order.order_items_to_paypal
      setup_response = @gateway.setup_purchase(total_as_cents, setup_purchase_params)
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
    @transaction = update_transaction(request, @purchase, session[:transaction_id])

    if @purchase.success?
      session[:cart] = []
    end
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

  def get_setup_purchase_params(order, request, items)
    total = to_cents(order.total + (order.shipping_cost || 0))

    return total, {
      :ip => request.remote_ip,
      :return_url => url_for(:action => 'review', :only_path => false),
      :cancel_return_url => cart_url,
      :subtotal => total,
      :header_background_color => 'ff0000',
      :allow_note =>  true,
      :email => current_user.email,
      :allow_guest_checkout => true,
      :locale => 'pt_BR',
      :currency => 'BRL',
      :payment_method => "credit_card",
      :items => items
      }
  end

  def get_purchase_params(order, request, items, params)
    return to_cents(order.total), {
      :ip => request.remote_ip,
      :token => params[:token],
      :payer_id => params[:PayerID],
      :subtotal => to_cents(order.total),
      :locale => 'pt_BR',
      :currency => 'BRL',
      :items => items
    }
  end

  def to_cents(money)
    (money.to_f*100).round
  end

  def update_transaction(request, purchase, transaction_id)
    transaction = Transaction.where(:id => transaction_id).last
    if transaction.status == Transaction::CREATED
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
        :status => (purchase.success? == true)? Transaction::COMPLETED : Transaction::FAILED
        )
    end
    transaction
  end


end
