# putting everything here since it seems to be bit overkill to create its own controller for 1 route. If app scales up, please seperate out to it's own controller

# TODO: make api version control

require "email_services"

class ApplicationController < ActionController::API

  before_action :authenticate_request
  before_action :validate_params

  rescue_from StandardError, with: :_include_error_info_in_response

  def initialize
    @response = { }
  end


  # POST /email
  # sample response accepted
  # {
  #   “to”: “forreal@reallife.com”,
  #   “to_name”: “Ms. Right”,
  #   “from”: “noreply@mybrightwheel.com",
  #   “from_name”: "Brightwheel",
  #   “subject”: “We are looking for Ms. Right"
  #   “body”: “<h1>Are you</h1><p>her?</p>”
  # }

  def send_email
    if ApplicationMailer.notification(params).deliver
      @response       = {success: true}
      _render_response
    else
      raise EmailServices::EmailServiceError, "Sorry, something went wrong while sending your email."
    end
  end

  private

  def authenticate_request
    # in full scale app, you would probably would want to authenticate request against real user database
    raise EmailServices::UnauthenticatedError, "Sorry your request is unauthenticated." unless params[:token] == "yeswearebright"
  end

  def validate_params
    missing_params = EmailServices::REQUIRED_FIELDS - params.keys
    if missing_params.present?
      raise EmailServices::MissingFieldsError, missing_params
    end

    # ideally, you would want to validate the email against user table and make sure they don't have email notification turned off
    unless EmailServices::valid_email?(params[:to])
      raise EmailServices::InvalidEmailError, "We can not validate to email address, please double check your input and try again."
    end

    # make sure the email send to your users is from a permitted and valid org email
    unless Settings.permitted_org_emails.include?(params[:from])
      raise EmailServices::InvalidEmailError, "Sorry, your from email input is not from an authorized address."
    end
  end

  def _render_response(status_code=nil)
    render({ json: @response, status: status_code || 200 })
  end


  def _include_error_info_in_response(exception)
    @response[:errors]            ||= {}
    wrapper = ActionDispatch::ExceptionWrapper.new(nil, exception)
    trace   = wrapper.application_trace
    trace   = wrapper.framework_trace if trace.empty?
    
    case exception
    when EmailServices::UnauthenticatedError
        @response[:errors][:code]     = :authentication_error
    when EmailServices::MissingFieldsError
        @response[:errors][:code]     = :missing_fields
    when EmailServices::InvalidEmailError
        @response[:errors][:code]     = :invalid_email
    end

    @response[:errors][:code]     ||= :email_error
    @response[:errors][:message]  ||= [exception.message]

    if Rails.env.development?
      @response[:errors][:trace]  ||= trace
    end

    _render_response(400)

  end
end
