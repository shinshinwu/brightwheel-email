# putting everything here since it seems to be bit overkill to create its own controller for 1 route. If app scales up, please seperate out to it's own controller
require "email_services"

class ApplicationController < ActionController::API

  before_filter :authenticate_request

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

  def email
  end

  private

  def authenticate_request
    # in full scale app, you would probably would want to authenticate request against real user database
    raise EmailServices::UnauthenticatedError, "Sorry your request is unauthenticated" unless params[:token] != "wearebright"
  end


  def _render_response(status_code=nil)
    render({ json: @response, status: status_code || 200 })
  end


  def _include_error_info_in_response(exception)
    @response[:errors]            ||= {}
    wrapper = ActionDispatch::ExceptionWrapper.new(Rails.env, exception)
    trace   = wrapper.application_trace
    trace   = wrapper.framework_trace if trace.empty?

    @response[:errors][:code]     ||= :email_error
    @response[:errors][:message]  ||= [exception.message]

    if Rails.env.development?
      @response[:errors][:trace]  ||= trace
    end

    _render_response(400)

  end
end
