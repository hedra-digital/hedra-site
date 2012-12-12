class BooksController < ApplicationController
  def show
    @book = Book.includes(:participations => [:person, :role]).find(params[:id])
  end
end
