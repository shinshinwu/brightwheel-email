class ApplicationController < ActionController::API
  include EmailHelper

  before_filter :authenticate_request

  rescue_from StandardError, with: :_include_error_info_in_response

  def initialize
    @response = { }
  end

  # POST /email
  def email
  end

  private

  def authenticate_request
    unless params[:token] == "wearebright"
    end
  end
end
