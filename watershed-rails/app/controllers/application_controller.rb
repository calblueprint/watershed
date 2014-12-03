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

  def unauthorized_response
    render json: { message: "Unauthorized" }, status: 403
  end

end
