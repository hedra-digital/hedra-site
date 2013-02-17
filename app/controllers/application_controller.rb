class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :get_categories, :get_cart_items, :get_cart_price

  protected

  def get_categories
    @category_list ||= Category.all
  end

  def get_cart_items
    if session[:cart]
      @cart_items ||= []
      session[:cart].each do |book_id, quantity|
        book = Book.includes(:participations => [:person, :role]).find(book_id)
        @cart_items << [book, quantity]
      end
    end
  end

  def get_cart_price
    if @cart_items
      @cart_price = @cart_items.inject(0) { |sum, ele| sum += (ele[0].price_print * ele[1]) }
    end
  end
end
