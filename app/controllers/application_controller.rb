class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :get_categories, :build_cart, :get_cart_items

  protected

  def get_categories
    @category_list ||= Category.all
  end

  def get_cart_items
    @cart_items ||= Cart.all
  end

  def build_cart
    if session[:cart]
      session[:cart].each do |book_id, quantity|
        Cart.update_or_initialize(:book_id => book_id, :quantity => quantity)
      end
    end
  end
end
