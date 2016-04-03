class PaymentController < ApplicationController
  layout "application"

  skip_before_filter :verify_authenticity_token, :only => [:callback_9E93257460]
  skip_before_filter :filter,                    :only => [:callback_9E93257460]

  def credit_card
    return if order_validation_triggered_redirect?(true)

    @order = nil

    begin
      @order = create_order(current_user, params[:address], session[:cart], Transaction::CREDIT_CARD, params[:cpf_cnpj], params[:telephone], params[:shipping_type])
    rescue ArgumentError => e
      redirect_to cart_url, :alert => "Erro AO calcular custo do frete." and return
    end

    Iugu.api_key = APP_CONFIG["iugu_api_key"]
    payment_params = { token: params[:token], email: current_user.email, items: @order.order_items_to_iugu }
    payment_params[:months] = params[:months] unless params[:months].blank?
    iugu_charge = Iugu::Charge.create(payment_params)
    PaymentLogger.log(iugu_charge.errors.to_s) if iugu_charge.errors.present?
    
    @transaction = @order.transactions.last
    @transaction.customer_ip = request.remote_ip
    @transaction.payment_status = Transaction::PENDING
    @transaction.invoice_id = iugu_charge.invoice_id
    @transaction.save

    if iugu_charge.invoice.status == Transaction::PAID
      session[:cart] = []
      render :template => "checkout/review"
      return
    else
      redirect_to cart_url, :alert => "Não foi possível finalizar a sua compra, #{iugu_charge.message}"
      return
    end 

  end


  def bank_slip
    return if order_validation_triggered_redirect?

    @order = nil

    begin
      @order = create_order(current_user, params[:address], session[:cart], Transaction::BANK_SLIP, params[:cpf_cnpj], params[:telephone], params[:shipping_type])
    rescue ArgumentError => e
      redirect_to cart_url, :alert => "Erro AO calcular custo do frete." and return
    end

    Iugu.api_key = APP_CONFIG["iugu_api_key"]

    iugu_charge = Iugu::Charge.create({
      method: "bank_slip",
      email: current_user.email,
      items: @order.order_items_to_iugu,
      payer: {
        cpf_cnpj: params[:cpf_cnpj],
        name: params[:client_name],
        phone_prefix: params[:telephone].gsub("(", "").gsub(")","").split.first,
        phone: params[:telephone].gsub("(", "").gsub(")","").split.last,
        email: current_user.email 
      }
    })

    logger.info(iugu_charge.attributes)

    @transaction = @order.transactions.last
    @transaction.customer_ip = request.remote_ip
    @transaction.invoice_id = iugu_charge.invoice_id
    @transaction.payment_status = Transaction::PENDING
    @transaction.save

    if iugu_charge.success
      session[:cart] = []
      @bank_slip_url = iugu_charge.url
      @transaction.bank_slip_url = iugu_charge.url
      @transaction.save
      render :template => "checkout/review"
      return
    else
      redirect_to cart_url, :alert => "Não foi possível finalizar a sua compra"
      return
    end 

  end

=begin 
  make the name hard to guest for security
  test in dev:
  $.ajax({
   type: "POST",
   url: "/payment/callback_9E93257460",
   data:  JSON.stringify ({"event"=>"invoice.status_changed", "data"=>{"id"=>"8DF7CD0B6B9547D69B1E13418B829548", "status"=>"paid"}}),
   contentType: "application/json; charset=utf-8",
   dataType: "json"
  });

=end 
  def callback_9E93257460

    if params[:event] != "invoice.status_changed"
      render text: "event does not match"
      return
    end

    transaction = Transaction.find_by_invoice_id(params[:data][:id])

    if transaction.nil?
      render text: "invoice not found"
      return
    end

    transaction.payment_status = params[:data][:status]

    if transaction.payment_status == Transaction::PAID
      transaction.status = Transaction::COMPLETED
    elsif transaction.payment_status == Transaction::CANCELED or transaction.payment_status == Transaction::EXPIRED
      transaction.status = Transaction::FAILED
    end

    transaction.save

    render text: "ok"
  end

end

