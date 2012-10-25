class PagesController < ApplicationController

  def home
    @features = Feature.all
  end

  def about
  end

end
