module EmailServices

  class EmailServiceError < StandardError
    def initialize(message="")
      super(message)
    end
  end

  class UnauthenticatedError < EmailServiceError; end

end
