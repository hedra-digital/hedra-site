class BooksController < ApplicationController
  def show
    @book = Book.includes(:participations => [:person, :role]).find(params[:id])
  end

  def by_category
    @category = Category.find(params[:id])
    @books    = @category.books.includes(:participations => [:person, :role]).paginate(:page => params[:page], :per_page => 10)
  end

  def search
    @books = Book.search(params[:term], :page => params[:page], :per_page => 5)
  end
end
