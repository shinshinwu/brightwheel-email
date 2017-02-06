module EmailServices

  REQUIRED_FIELDS = ["to", "to_name", "from", "from_name", "subject", "body"]

  class EmailServiceError < StandardError
    def initialize(message="")
      super(message)
    end
  end

  class UnauthenticatedError < EmailServiceError; end
  class MissingFieldsError < EmailServiceError
    def initialize(missing_fields)
      super("Missing required inputs for #{missing_fields.to_sentence} fields. Please compelete all required fields and try again.")
    end
  end

  class InvalidEmailError < EmailServiceError; end

  class self.valid_email?(email_address)
    invalid_email_chars  = /\A\s*([-\p{L}\d+._]{1,64})@((?:[-\p{L}\d]+\.)+\p{L}{2,})\s*\z/i

    # regex return 0 if email input is valid
    (email =~ invalid_email_chars) == 0
  end

  class self.send_mailgun

    Mail.defaults do
      delivery_method :smtp, {
        :port      => 587,
        :address   => "smtp.mailgun.org",
        :user_name => ENV["MAILGUN_USER"],
        :password  => ENV["MAILGUN_PW"],
      }
    end

    mail = Mail.deliver do
      to      'bar@example.com'
      from    'foo@YOUR_DOMAIN_NAME'
      subject 'Hello'

      text_part do
        body 'Testing some Mailgun awesomness'
      end
    end
  end

  class self.send_mandrill
    Mail.defaults do
      delivery_method :smtp, {
        :port      => 587,
        :address   => "smtp.mandrillapp.com",
        :user_name => ENV["MANDRILL_USER"],
        :password  => ENV["MANDRILL_PW"],
        :authentication => 'login'
      }
    end

    mail = Mail.deliver do
      to      'bar@example.com'
      from    'foo@YOUR_DOMAIN_NAME'
      subject 'Hello'

      text_part do
        body 'Testing some mandrill awesomness'
      end
    end
  end

end