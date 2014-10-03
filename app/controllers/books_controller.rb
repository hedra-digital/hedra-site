class BooksController < ApplicationController
  before_filter :resource, :only => :show

  def show
    @related_books ||= @book.tags.map(&:books).flatten.uniq.delete_if{|x| x.id == @book.id}.sort_by{|x| x.title}.first(16)
  end

  def by_category
    @category = Category.find(params[:id])

    books_query = Book.joins(:category).includes(:participations => [:person, :role]).where("categories.id = #{@category.id}").order("books.publisher_id, books.position desc, books.id desc")
    books_count = books_query.count

    @highlight = books_query.first(4) if books_count >= 6 and (params[:page].nil? or params[:page] == "1")
    @books = books_query.paginate(:page => params[:page], :per_page => 10, :offset => (books_count >= 6 ? 4 : 0), :total_entries => (books_count >= 6 ? books_count - 4 : books_count))

  end

  def search
    term = "%#{params[:term]}%"
    
    # match the whole name
    author = Person.where(name: params[:term]).first
    page = author.page if author

    if author and page
     redirect_to url_for(controller: "pages", action: "author", name: author.name)
     return
    end

    books_query = Book.joins(participations: [:role, :person]).where("books.title LIKE ? OR books.isbn LIKE ? OR books.description LIKE ? OR people.name LIKE ?", term, term, term, term).order("books.publisher_id, books.position desc, books.id desc").uniq
    books_count = books_query.count
    
    @highlight = books_query.first(4) if books_count >= 6 and (params[:page].nil? or params[:page] == "1")
    @books = books_query.paginate(:page => params[:page], :per_page => 5, :offset => (books_count >= 6 ? 4 : 0), :total_entries => (books_count >= 6 ? books_count - 4 : books_count))
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
