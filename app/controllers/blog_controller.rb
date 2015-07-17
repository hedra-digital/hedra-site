# -*- encoding : utf-8 -*-
class BlogController < ApplicationController

  def index
    @posts = Post.joins(:book).includes(:book => { :participations => [:person, :role] })
    .where("books.publisher_id = #{session[:publisher]}")
    .order("created_at desc")
    .paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @post = Post.includes(:book => { :participations => [:person, :role] }).find(params[:id])
  end
end
