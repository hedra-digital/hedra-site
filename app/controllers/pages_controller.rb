class PagesController < ApplicationController

  def home
    @features = Feature.includes(:book => { :participations => [:person, :role] }).first(1)
    @new_releases = NewRelease.includes(:book => { :participations => [:person, :role] }).map(&:book).first(4)
    @recommendations = Recommendation.includes(:book => { :participations => [:person, :role] }).map(&:book)
  end

  def about
  end

  def contact
  end

  def tag
    @page = Tag.find(params[:id]).page
    @books = @page.tag.books.includes( :participations => [:person, :role] )
  end
end
