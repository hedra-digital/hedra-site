# -*- encoding : utf-8 -*-
class RegistrationsController < Devise::RegistrationsController
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
    end
    respond_to do |format|
      format.js
    end
  end
end
