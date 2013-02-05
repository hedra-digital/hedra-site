class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :get_categories, :cart_books

  protected

  def get_categories
    @category_list ||= Category.all
  end

  def cart_books
    @cart_books = if session['cart']
      session['cart'].map { |book_id| Book.includes(:participations => [:person, :role]).find(book_id) }
    else
      []
    end
  end
end
