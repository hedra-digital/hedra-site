class PagesController < ApplicationController

  def home
    @features = Feature.includes(:book).all
  end

  def about
  end

end
