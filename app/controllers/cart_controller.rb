class CartController < ApplicationController
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper

  def index
    if session[:cart].blank?
      redirect_to "/", :alert => "Não foi possível finalizar a sua compra, pois não há itens no seu carrinho de compras."
      return
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

end
