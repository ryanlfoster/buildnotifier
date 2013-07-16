class PasswordResetsController < ApplicationController
  skip_before_filter :validate_user

  def new
    @password_reset = PasswordReset.new
  end

  def create
    @user = User.where(email: params[:email]).first

    if @user
      @user.password_reset.destroy unless @user.password_reset.nil?
      @user.create_password_reset

      redirect_to login_url, notice: t(:sent_password_reset_instruction)
    else
      redirect_to new_password_reset_url, alert: t(:could_not_find_a_user_with_that_email_address)
    end
  end

  def claim
    @password_reset = PasswordReset.where(_id: params[:id]).and(code: params[:code]).first

    unless @password_reset
      redirect_to login_url, alert: t(:invalid_password_reset_code)
    end
  end

  def update
    @password_reset = PasswordReset.where(_id: params[:password_reset_id]).and(code: params[:password_reset_code]).first

    unless @password_reset
      redirect_to login_url, alert: t(:invalid_password_reset_code) 
    else
      @user = @password_reset.user

      if @user.has_authorization :identity
        @identity = @user.identity
        @identity.update_attributes params.slice(:password, :password_confirmation)

        if @identity.save
          @password_reset.destroy
          session[:user_id] = @user.id
          redirect_to edit_user_url(@user), notice: t(:profile_updated)
        else
          redirect_to claim_password_reset_url(@password_reset.id, @password_reset.code), alert: object_errors(@identity)
        end
      else
        redirect_to login_url, alert: t(:no_password_for_user)
      end
    end
  end
end
