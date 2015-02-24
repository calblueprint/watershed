class Api::V1::UsersController < Api::V1::BaseController
  skip_before_filter :authenticate_user_from_token!, only: [:create, :facebook_login]
  skip_before_filter :authenticate_api_v1_user!,     only: [:create, :facebook_login]
  load_and_authorize_resource param_method: :user_params

  def index
    render json: @users, each_serializer: UserListSerializer
  end

  def search
    @users = @users.search(params[:q])
    render json: @users, each_serializer: UserListSerializer
  end

  def show
    render json: @user, serializer: UserSerializer
  end

  def create
    if @user.save
      successful_login(@user)
    else
      error_response(@user)
    end
  end

  def facebook_login
    @user = User.where(email: params[:user][:email]).first_or_initialize
    return successful_login(@user) if @user.valid_facebook_token?(params[:user][:facebook_auth_token])

    if @user.create_with_facebook_info(params[:user])
      successful_login(@user)
    else
      invalid_facebook_login_attempt
    end
  end

  def update
    binding.pry
    if @user.update_with_password(user_params)
      render json: @user, serializer: UserSerializer
    else
      error_response(@user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :role, :password, :current_password
                                 :password_confirmation, :facebook_auth_token)
  end

  def invalid_facebook_login_attempt
    error_response(nil, "There was a problem signing in with Facebook.", 401)
  end

end
