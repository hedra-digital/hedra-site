class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :get_categories, :cart_books

  protected

  def get_categories
    @category_list ||= Category.all
  end

  def cart_books
    @cart_books = []
    if session['cart']
      session['cart'].each do |book_id|
        @cart_books << Book.find(book_id)
      end
    else
      @cart_books = nil
    end
    @cart_books
  end
end
