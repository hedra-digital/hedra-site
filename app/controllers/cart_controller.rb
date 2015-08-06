class CartController < ApplicationController
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper

  def index
    if session[:cart].blank?
      redirect_to "/", :alert => "Não foi possível finalizar a sua compra, pois não há itens no seu carrinho de compras."
      return
    end

    @default_phone    = nil
    @default_cpf      = nil
    @default_address  = nil
    @shipment_costs   = nil

    if current_user

      last_order = Order.where(user_id: current_user.id).order("id").last

      if last_order
        @default_phone    = last_order.telephone
        @default_cpf      = last_order.cpf_cnpj
        @default_address  = last_order.address
      end
    end

    @cep = @default_address.nil? ? nil : @default_address.zip_code

    if session[:cart].size > 0
      @shipment_costs   = ::ShipmentCalculatorService.execute(session[:cart], @cep) #nil when there aren't printed books.
    end
  end

  def create
    @book = Book.find(params[:id])
    book_type = params[:book_type].to_sym

    order_item = session[:cart].detect{ |item| item[:book_id] == @book.id and item[:book_type] == book_type}

    if order_item == nil
      session[:cart] << {book_id: @book.id, book_type: book_type, quantity: 1}
    else
      order_item[:quantity] += 1
    end

    flash[:info] = "<strong>Subtotal do seu pedido: #{number_to_currency(view_context.cart_total)}</strong><br>Você tem #{pluralize(session[:cart].size, 'item', 'itens')} no carrinho.<a class='btn btn-primary view-cart' href='/carrinho'>Ver carrinho</a>"
    redirect_to :back
  end

  def update
    session[:cart] = []
    params[:cart].each do |key, value|
      if key.include?('_') && value.present?
        book_id, book_type = key.split("_")
        session[:cart] << {book_id: book_id.to_i, book_type: book_type.to_sym, quantity: value.to_i} if value.to_i != 0
      end
    end
    redirect_to cart_path
  end

  def destroy
    book = Book.find(params[:id])
    book_type = params[:book_type].to_sym
    order_item = session[:cart].detect{ |item| item[:book_id] == book.id and item[:book_type] == book_type}
    session[:cart] = session[:cart] - [order_item]
    redirect_to :back
  end

  def shipment_cost
    @cep   = params[:cep]
    @shipment_costs   = ::ShipmentCalculatorService.execute(session[:cart], @cep)
  end

  private

    def come_from_blog?
      request.referer =~ /\/blog(\/|$)/
    end
end
