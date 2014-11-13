class Api::V1::UsersController < Api::V1::BaseController
  load_and_authorize_resource param_method: :user_params

  def index
    render json: @users
  end

  def show
    render json: @user
  end

  def create
    if @user.save
      render json: @user
    else
      render json: { errors: @user.errors }, status: 422
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: { errors: @user.errors }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :role)
  end

end
