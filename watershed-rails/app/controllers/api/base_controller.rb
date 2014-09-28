class Api::BaseController < ApplicationController
  prepend_before_filter :get_authentication_token
  prepend_before_filter :get_email

  respond_to :json

  private

  def get_authentication_token
    if auth_token = params[:auth_token].blank? && request.headers["X-AUTH-TOKEN"]
      params[:auth_token] = auth_token
    end
  end

  def get_email
    if email = params[:email].blank? && request.headers["X-AUTH-EMAIL"]
      params[:email] = email
    end
  end

end
