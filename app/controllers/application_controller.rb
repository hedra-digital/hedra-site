# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :get_categories, :get_cart_items, :get_cart_price

  before_filter :http_authenticate

protected

  def http_authenticate
    if Rails.env == 'staging'
      authenticate_or_request_with_http_basic do |username, password|
        username == "Lovecraft" && password == "Necronomicon"
      end
    end
  end

  def get_categories
    @category_list ||= Category.all
  end

  def get_cart_items
    if session[:carrinho]
      @cart_items ||= []
      session[:carrinho].each do |book_id, quantity|
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

  def not_found
    raise ActiveRecord::RecordNotFound
  end
end
