class PaymentController < ApplicationController
  layout "application"

  def index
    render partial: "index"
  end

  def pay
    @address = Address.find(session[:address_id])
    @order = create_order(current_user, @address, session[:carrinho])
    if !@order.nil?

      Iugu.api_key = APP_CONFIG["iugu_api_key"]
      iugu_charge = Iugu::Charge.create({ token: params[:token], email: current_user.email, items: @order.order_items_to_iugu } )

      @transaction = @order.transactions.last
      @transaction.customer_ip = request.ip,
      @transaction.status = iugu_charge.success ? Transaction::COMPLETED : Transaction::FAILED
      @transaction.invoice_id = iugu_charge.invoice_id
      @transaction.save

      if iugu_charge.success
        session[:carrinho] = nil
        render :template => "checkout/review"
        return
      else
        redirect_to cart_url, :alert => "Não foi possível finalizar a sua compra, #{iugu_charge.message}"
        return
      end 

    else
      redirect_to cart_url, :alert => "Não foi possível finalizar a sua compra, pois não há itens no seu carrinho de compras."
      return
    end
  end

end

