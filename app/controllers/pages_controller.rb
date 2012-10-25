class PagesController < ApplicationController

  def home
    @featured_books = Feature.includes(:book).all.map { |e| e.book  }
  end

  def about
  end

end
