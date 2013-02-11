# encoding: UTF-8

class CartController < ApplicationController
  before_filter :resource, :only => [:create, :destroy]

  # TODO: Do I really need a full AR object for this?

  def index
  end

  def create
    Cart.new(@book)
    session[:cart] = {} unless session[:cart]
    session[:cart][@book.id] = 1
    flash[:info] = "Subtotal do seu pedido: #{Cart.total_price}<br>Você tem #{@cart_items.size} itens no carrinho."
    redirect_to :back
  end

  def update
    params[:cart].each do |key, value|
      if key.include?('quantity_') && value.present?
        book_id = key.scan(/(?<=quantity_)\d*/).join.to_i
        quantity = value.to_i
        Cart.update_or_initialize(:book_id => book_id, :quantity => quantity)
        session[:cart][book_id] = quantity
      end
    end
    redirect_to cart_path
  end

  def destroy
    Cart.find(@book.id).delete
    session[:cart].delete(@book.id)
    redirect_to :back
  end

  private

  def resource
    @book = Book.find(params[:id])
  end
end
