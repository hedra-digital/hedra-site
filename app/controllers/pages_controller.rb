# -*- encoding : utf-8 -*-
class PagesController < ApplicationController

  def home
    @features        = Feature.includes(:page).joins(:book).includes(:book => { :participations => [:person, :role] }).where("books.publisher_id = #{session[:publisher]}").first(6)
    @new_releases    = NewRelease.joins(:book).includes(:book => { :participations => [:person, :role] }).where("books.publisher_id = #{session[:publisher]}").first(4).map(&:book)
    @recommendations = Recommendation.joins(:book).includes(:book => { :participations => [:person, :role] }).where("books.publisher_id = #{session[:publisher]}").map(&:book)
  end

  def about
  end

  def contact
  end

  def tag
    @tag   = Tag.where(:name => params[:id]).first || not_found
    @books = @tag.books.includes(:participations => [:person, :role]).where("books.publisher_id = #{session[:publisher]}")
    @page  = @tag.page
  end
end
