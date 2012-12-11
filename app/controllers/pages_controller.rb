class PagesController < ApplicationController

  def home
    @features = Feature.includes(:book => :people).map(&:book).first(1)
    @new_releases = NewRelease.includes(:book => :people).map(&:book).first(4)
    @recommendations = Recommendation.includes(:book => :people).map(&:book)
  end

  def about
  end

  def contact
  end

end
