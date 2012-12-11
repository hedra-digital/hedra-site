class PagesController < ApplicationController

  def home
    @features = Feature.includes(:books, :people).all.map(&:book).first(1)
    @new_releases = NewRelease.includes(:book).all.map(&:book).first(4)
    @recommendations = Recommendation.includes(:book).all.map(&:book)
  end

  def about
  end

  def contact
  end

end
