class BaseMailer < ActionMailer::Base
  helper ActionView::Helpers::UrlHelper
  layout 'email'

  default charset: "utf-8"
  default content_type: "text/html"
  default from: Settings.email_sender
  default_url_options[:host] = Settings.domain
end
