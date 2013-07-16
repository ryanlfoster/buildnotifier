class ReleaseMailer < BaseMailer
  def release_notification(emails, release, step)
    @release = release
    @approval_step = step
    mail to: emails.join(","), subject: t("mailer.release_notification.subject", name: release.descriptive_name)
  end

  def detailed_notification(emails, approval_status, old_status, new_status)
    @release = approval_status.release
    @product = approval_status.release.product
    @actioner = approval_status.user
    @approval_status = approval_status
    @approval_step = approval_status.approval_step
    @old_status = old_status
    @new_status = new_status

    mail to: emails.join(","), subject: t("mailer.detailed_notification.subject", release_name: @release.descriptive_name, approval_step_name: @approval_step.name, status: @new_status.to_s.upcase)
  end

  def overall_status_change(release)
    @release = release
    mail to: @release.creator.email, subject: t("mailer.overall_status_change.subject", release_name: @release.descriptive_name, status: @release.overall_status.to_s)
  end
end
