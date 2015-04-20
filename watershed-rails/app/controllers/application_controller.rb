class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery

  rescue_from CanCan::AccessDenied, ActiveRecord::RecordNotFound do |exception|
    unauthorized_response
  end

  def successful_login(user)
    sign_in(:user, user)
    user.ensure_authentication_token
    render json: user, serializer: SessionSerializer
  end

  def error_response(object, message = nil, status = nil)
    render json: Error.new(object, message), serializer: ErrorSerializer, status: status || 403
  end

  def unauthorized_response
    error_response(nil, "Unauthorized", 403 )
  end

end
