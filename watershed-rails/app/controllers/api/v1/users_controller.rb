class Api::V1::UsersController < Api::V1::BaseController
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
      render json: @user, serializer: UserSerializer
    else
      render json: { errors: @user.errors }, status: 422
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, serializer: UserSerializer
    else
      render json: { errors: @user.errors }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :role)
  end

end
