class BooksController < ApplicationController

  def show
    @book = Book.with_participations.find(params[:id]) rescue not_found
    @related_books ||= @book.related
  end

  def by_category
    @category = Category.find(params[:id])
    books_query = Book.with_participations.find_by_category(@category.id).default_order

    @highlight = book_highlights(books_query)
    @books = book_paginate(books_query, per_page: 20)
  end

  def search
    author = Person.find_by_name(params[:term])

    if author && author.site_page
      redirect_to author_page_path(name: author.name)
    end
    books_query = Book.with_participations.find_by_term("%#{params[:term]}%").default_order.uniq

    @highlight = book_highlights(books_query)
    @books = book_paginate(books_query, per_page: 5)
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

  def book_highlights(books)
    books.first(4) if books.count >= 6 && first_page
  end

  def book_paginate(book, per_page: 10)
    book.paginate(
      page: params[:page],
      per_page: per_page,
      offset: default_offset(book.count),
      total_entries: (book.count >= 6 ? book.count - 4 : book.count)
    )
  end

  def first_page
    params[:page].nil? || params[:page] == "1"
  end

  def default_offset(counter)
    (counter >= 6 ? 4 : 0)
  end
end
