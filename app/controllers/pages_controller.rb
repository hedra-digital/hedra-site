class PagesController < ApplicationController

  def home
    @features        = Feature.includes(:book => { :participations => [:person, :role] }).first(6)
    @new_releases    = NewRelease.includes(:book => { :participations => [:person, :role] }).map(&:book).first(4)
    @recommendations = Recommendation.includes(:book => { :participations => [:person, :role] }).map(&:book)
  end

  def about
  end

  def contact
  end

  def tag
    @tag   = Tag.where(:name => params[:id]).first
    @books = @tag.books.includes(:participations => [:person, :role])
    @page  = @tag.page
  end

  def cart
  end

  def posts
    if params[:id]
      @post = Post.where(:id => params[:id]).first
      render "single_post"
    else
      @posts = Post.all
    end
  end
end
