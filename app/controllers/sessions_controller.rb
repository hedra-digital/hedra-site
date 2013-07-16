# -*- encoding : utf-8 -*-
class SessionsController < Devise::SessionsController

  def create
    @user = User.where(:email => params[:user][:email]).first
    if !@user.nil? && @user.valid_password?(params[:user][:password])
      sign_in @user
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    sign_out current_user
    respond_to do |format|
      format.js
    end
  end

end

