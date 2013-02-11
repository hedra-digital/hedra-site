class CartController < ApplicationController
  before_filter :resource, :only => [:create, :destroy]

  # TODO: Do I really need a full AR object for this?

  def index
  end

  def create
    create_cart_item
    flash[:info] = "Subtotal do seu pedido: O livro <em>#{@book.title}</em> foi adicionado ao carrinho!"
    redirect_to :back
  end

  def update
    params[:cart].each do |key, value|
      if key.include?('quantity_') && value.present?
        book_id = key.scan(/(?<=quantity_)\d*/).join.to_i
        quantity = value.to_i
        session[:cart][book_id] = quantity
      end
    end
    redirect_to cart_path
  end

  def destroy
    binding.pry
    session[:cart].delete(@book.id)
    redirect_to :back
  end

  private

  def resource
    @book = Book.find(params[:id])
  end

  def create_cart_item
    session[:cart] ||= {}
    if session[:cart][@book.id].nil?
      session[:cart][@book.id] = 1
    else
      session[:cart][@book.id] += 1
    end
  end
end
