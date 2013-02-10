class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :get_categories, :cart_books

  protected

  def get_categories
    @category_list ||= Category.all
  end

  def cart_books
    if session['cart']
      @cart_books ||= {}
      session['cart'].each do |book_id, amount|
        cart_item = Book.includes(:participations => [:person, :role]).find(book_id)
        @cart_books[cart_item] ||= amount
      end
    end
  end
end
