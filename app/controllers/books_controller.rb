class BooksController < ApplicationController
  before_filter :resource, :only => [:show, :add_to_cart, :remove_from_cart]
  def show  
  end

  def by_category
    @category = Category.find(params[:id])
    @books    = @category.books.includes(:participations => [:person, :role]).paginate(:page => params[:page], :per_page => 10)
  end

  def search
    @books = Book.search(params[:term], :page => params[:page], :per_page => 5, :include => { :participations => [:person, :role] }, :field_weights => { :title => 10 })
  end

  def add_to_cart
    session['cart'] ||= []
    session['cart'] << @book.id
    session['cart'].uniq!
    redirect_to :back
  end

  def remove_from_cart
    session['cart'].delete(@book.id)
    redirect_to :back
  end

  private
  
  def resource
    @book = Book.includes(:participations => [:person, :role]).find(params[:id])
  end
end
