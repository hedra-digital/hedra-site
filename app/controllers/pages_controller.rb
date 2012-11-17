class PagesController < ApplicationController

  def home
    @features = Feature.includes(:book).all.map { |e| e.book  }
    @new_releases = NewRelease.includes(:book).all.map { |e| e.book }
    @recommendations = Recommendation.includes(:book).all.map { |e| e.book }
  end

  def about
  end

  def contact
  end

end
