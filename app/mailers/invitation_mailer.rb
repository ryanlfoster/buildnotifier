class InvitationMailer < BaseMailer
  def invitation(invite)
    @invite = invite
    @user = invite.user
    mail(to: @user.email, subject: I18n.t(:email_invitation_subject))
  end
end
