class CartController < ApplicationController
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper

  before_filter :resource, :only => [:create, :destroy]

  def index
    if session[:carrinho].blank?
      redirect_to "/", :alert => "Não foi possível finalizar a sua compra, pois não há itens no seu carrinho de compras."
      return
    end
  end

  def create
    session[:carrinho] ||= {}
    session[:carrinho][@book.id] = 0 unless session[:carrinho][@book.id]
    session[:carrinho][@book.id] += 1
    @cart_items ||= []
    if @cart_items.present?
      @cart_items.each do |book, quantity|
        if book = @book
          @cart_items.delete([book, quantity])
          @cart_items << [book, (quantity + 1)]
        end
      end
    else
      @cart_items << [@book, 1]
    end
    @cart_price ||= 0
    @cart_price += view_context.show_price(@book)
    flash[:info] = "<strong>Subtotal do seu pedido: #{number_to_currency(@cart_price)}</strong><br>Você tem #{pluralize(@cart_items.size, 'item', 'itens')} no carrinho.<a class='btn btn-primary view-cart' href='/carrinho'>Ver carrinho</a>"
    redirect_to :back
  end

  def update
    params[:cart].each do |key, value|
      if key.include?('quantity_') && value.present?
        book_id = key.scan(/(?<=quantity_)\d*/).join.to_i
        quantity = value.to_i
        session[:carrinho][book_id] = quantity
      end
    end
    redirect_to cart_path
  end

  def destroy
    session[:carrinho].delete(@book.id)
    redirect_to :back
  end

  private

  def resource
    @book = Book.find(params[:id])
  end
end
