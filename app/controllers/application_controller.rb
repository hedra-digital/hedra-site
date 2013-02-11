class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :get_categories, :get_cart_items

  protected

  def get_categories
    @category_list ||= Category.all
  end

  def get_cart_items
    @cart_items ||= Cart.all
  end
end
