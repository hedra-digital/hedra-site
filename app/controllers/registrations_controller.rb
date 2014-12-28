class RegistrationsController < Devise::RegistrationsController
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
    else
    	error_messages = ""
		  @user.errors.full_messages.each do |message|
		    error_messages << "<li>#{message}</li>" 
		  end 
    	flash.alert = error_messages
    end

    respond_to do |format|
    	format.html {redirect_to stored_location_for(:user) || root_path} if @user.errors.count == 0
      format.html { redirect_to (new_session_path(resource_name)) } if @user.errors.count > 0
      format.js
    end

  end
end

