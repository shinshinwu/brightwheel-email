class ApplicationMailer < ActionMailer::Base
  default from: 'support@brightwheel.com'
  layout 'mailer'

  include ActionView::Helpers::SanitizeHelper

  def notification(email_params, email_service=nil)
    recipient = email_params[:to]
    sender    = email_params[:from]

    subject   = email_params[:subject]
    body      = strip_tags(email_params[:body])

    email_service ||= Settings.default_email_service

    smtp_credentials = {
      user_name: ENV["#{email_service.upcase}_USER"],
      password:  ENV["#{email_service.upcase}_PW"]
    }

    # load other smtp params from settings file such as port and address etc
    delivery_options = smtp_credentials.merge(Settings[email_service])

    mail(to:                      recipient,
         from:                    sender,
         subject:                 subject,
         body:                    body,
         delivery_method_options: delivery_options
        )
  end
end
