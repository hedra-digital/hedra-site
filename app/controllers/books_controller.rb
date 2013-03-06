class BooksController < ApplicationController
  before_filter :resource, :only => :show

  def show
  end

  def by_category
    @category = Category.find(params[:id])
    @books    = @category.books.includes(:participations => [:person, :role]).paginate(:page => params[:page], :per_page => 10)
  end

  def search
    @books = Book.search(params[:term], :page => params[:page], :per_page => 5, :include => { :participations => [:person, :role] }, :field_weights => { :title => 10 })
  end

  private

  def resource
    @book = Book.includes(:participations => [:person, :role]).find(params[:id]) rescue not_found
  end
end
