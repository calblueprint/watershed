class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = "We're sorry, we couldn't find that page!"
    redirect_to root_path
  end
end
