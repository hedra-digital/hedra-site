class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :get_categories

  protected

  def get_categories
    @category_list ||= Category.all
  end
end
