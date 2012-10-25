class BooksController < ApplicationController
  def show
    @book = Book.includes(:people).find(params[:id])
    @author = @book.people.first
  end
end
