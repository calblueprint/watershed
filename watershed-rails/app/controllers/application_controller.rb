class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    unauthorized_response
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    not_found_response
  end

  def successful_login(user)
    sign_in(:user, user)
    user.ensure_authentication_token
    render json: user, serializer: SessionSerializer
  end

  def error_response(object, message = nil, status = nil)
    render json: Error.new(object, message), serializer: ErrorSerializer, status: status || 400
  end

  def unauthorized_response
    error_response(nil, "Unauthorized", 403)
  end

  def not_found_response
    error_response(nil, "Not Found", 404)
  end
end
