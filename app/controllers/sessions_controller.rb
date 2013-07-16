class SessionsController < ApplicationController
  skip_before_filter :validate_user
  before_filter :hide_header_link

  def new; end

  def failure
    flash[:alert] = t :incorrect_username_or_password
    redirect_to login_url
  end

  def create
    if @current_user = User.find_or_create_by_auth(auth)
      session[:user_id] = @current_user.id

      original_request = session[:original_request]
      session[:original_request] = nil
      redirect_to original_request || root_url
    else
      failure
    end
  end

  def destroy
    reset_session
    redirect_to login_url, notice: t(:you_have_been_logged_out)
  end

  def auth; request.env['omniauth.auth'] end
end
