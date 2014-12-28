class SessionsController < Devise::SessionsController

  def create
    @user = User.where(:email => params[:user][:email]).first
    if !@user.nil? && @user.valid_password?(params[:user][:password])
      sign_in @user
    else
      flash.alert = "Informações de acesso inválidas."
    end

    respond_to do |format|
      format.html {redirect_to stored_location_for(:user) || root_path} if @user
      format.html { redirect_to (new_session_path(resource_name)) } unless @user
      format.js
    end

  end

  def destroy
    session[:cart] = []
    sign_out current_user
    respond_to do |format|
      format.html { redirect_to(new_session_path(resource_name)) }
      format.js
    end
  end

end

