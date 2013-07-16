class InvitationsController < ApplicationController
  skip_before_filter :validate_user

  def show
    @invitation = Invitation.find params[:id]
  end

  def resend
    @invitation = Invitation.find params[:id]
    @invitation.send_invitation
    redirect_to @invitation, notice: t(:resent_invitation, email: @invitation.user.email)
  end

  def claim
    @invitation = Invitation.where(_id: params[:id]).and(code: params[:code]).first

    if @invitation
      @invitation.pending = false
      @invitation.save

      @user = @invitation.user
    else
      redirect_to login_url, alert: t(:invitation_code_invalid)
    end
  end
end
