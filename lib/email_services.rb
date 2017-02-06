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

  class InvalidEmailError < EmailServiceError
  end

  class self.valid_email?(email_address)
    invalid_email_chars  = /\A\s*([-\p{L}\d+._]{1,64})@((?:[-\p{L}\d]+\.)+\p{L}{2,})\s*\z/i

    # regex return 0 if email input is valid
    (email =~ invalid_email_chars) == 0
  end

end