# -*- encoding : utf-8 -*-
class BlogController < ApplicationController

  def index
    @posts = Post.includes(:book => { :participations => [:person, :role] }).all
  end

  def show
    @post = Post.includes(:book => { :participations => [:person, :role] }).find(params[:id])
  end
end
