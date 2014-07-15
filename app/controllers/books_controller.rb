# -*- encoding : utf-8 -*-
class BooksController < ApplicationController
  before_filter :resource, :only => :show

  def show
    @related_books ||= @book.tags.map(&:books).flatten.uniq.delete_if{|x| x.id == @book.id}.sort_by{|x| x.title}.first(16)
  end

  def by_category
    @category = Category.find(params[:id])
    @books    = @category.books.
                  includes(:participations => [:person, :role]).
                  paginate(:page => params[:page], :per_page => 10).
                  order("if(publisher_id = #{session[:publisher]},0,publisher_id)")
  end

  def search
    @term = "%#{params[:term]}%"
    @books = Book.joins(participations: [:role, :person]).
              where("roles.name in ('Texto', 'Autoria', 'Autor')").
              where("books.title LIKE ? OR books.isbn LIKE ? OR books.description LIKE ? OR people.name LIKE ?", @term, @term, @term, @term).
              paginate(:page => params[:page], :per_page => 5).
              order("if(publisher_id = #{session[:publisher]},0,publisher_id)")
  end

  def veneta_catalog
    @publisher_id = Publisher.where(:name => "Veneta").first.id
    @veneta_books = Book.where(:publisher_id => @publisher_id)
    render :json => @veneta_books.to_json, :callback => params['callback']
  end

  def veneta
    @veneta_book = Book.find_by_id(params[:id])
    @book_json = @veneta_book.as_json
    @book_json["binding_desc"] = @veneta_book.binding_type.name
    @book_json["category_desc"] = @veneta_book.category.name
    @book_json["book_comments"] = @veneta_book.book_comments.as_json
    render :json => @book_json.to_json, :callback => params['callback']
  end

  private

  def resource
    @book = Book.includes(:participations => [:person, :role]).find(params[:id]) rescue not_found
  end
end
