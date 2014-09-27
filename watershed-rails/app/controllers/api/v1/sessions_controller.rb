class API::V1::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    user = User.find_for_database_authentication(email: params[:user][:email])
    return invalid_login_attempt if user.nil?

    if user.valid_password?(params[:user][:password])
      sign_in(:user, user)
      user.ensure_authentication_token!
      render json: {
        authentication_token: user.authentication_token,
        email: user.email,
      }, status: :ok
    else
      invalid_login_attempt
    end
  end

end
