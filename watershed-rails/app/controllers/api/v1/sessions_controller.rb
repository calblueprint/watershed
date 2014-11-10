class Api::V1::SessionsController < Devise::SessionsController
  # Modified version of: https://gist.github.com/marcomd/3129118
  before_filter :authenticate_user!,  only: [:destroy]
  before_filter :ensure_params_exist, only: [:create]
  respond_to :json

  def create
    user = User.find_for_database_authentication(email: params[:user][:email])
    return invalid_login_attempt if user.nil?

    if user.valid_password?(params[:user][:password])
      sign_in(:user, user)
      user.ensure_authentication_token
      render json: {
        authentication_token: user.authentication_token,
        email: user.email,
      }.merge(JSON.parse(user.to_json)), status: :ok
    else
      invalid_login_attempt
    end
  end

  private

  def ensure_params_exist
    return unless params[:user].blank?
    render json: { message: "Missing user parameter" }, status: 422
  end

  def invalid_login_attempt
    render json: { message: "Incorrect login or password" }, status: 401
  end

end
