class PasswordResetMailer < BaseMailer
  def password_reset(reset)
    @reset = reset
    mail to: reset.user.email, subject: t(:build_notifier_password_reset) 
  end
end
