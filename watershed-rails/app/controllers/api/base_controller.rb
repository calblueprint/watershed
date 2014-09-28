class Api::BaseController < ApplicationController
  before_filter :authenticate_user!
  prepend_before_filter :get_authentication_token

  respond_to :json

  private

  def get_authentication_token
    if auth_token = params[:auth_token].blank? && request.headers["X-AUTH-TOKEN"]
      params[:auth_token] = auth_token
    end
  end

end
