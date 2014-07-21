class PagesController < ApplicationController

  def home
    @features = Feature.includes(:page).joins(:features_publishers).includes(:book => { :participations => [:person, :role] }).where("features_publishers.publisher_id = #{session[:publisher]}").first(6)

    @new_releases = Book.joins(:new_releases).where("books.publisher_id = #{session[:publisher]}").order("books.position desc, books.id desc").first(4)

    @recommendations = Book.joins(:recommendations).where("books.publisher_id = #{session[:publisher]}").order("books.position desc, books.id desc")
  end

  def about
  end

  def contact
  end

  def tag
    @tag   = Tag.where(:slug => params[:id]).first || not_found
    @books = Book.joins(:tags).where("books.publisher_id = #{session[:publisher]} and tags.id = #{@tag.id}").order("books.position desc, books.id desc")
    @page  = @tag.page
  end
end
