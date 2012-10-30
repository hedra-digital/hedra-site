class BooksController < ApplicationController
  def show
    @book = Book.includes(:participations, :people, :roles).find(params[:id])
  end
end
