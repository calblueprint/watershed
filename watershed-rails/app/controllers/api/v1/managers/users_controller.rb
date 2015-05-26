class Api::V1::Managers::UsersController < Api::V1::Managers::BaseController
  def promote
    @other_user = User.find_by(id: params[:other_user_id])
    if @other_user && @other_user.update(promotion_params)
      render json: @other_user, serializer: UserSerializer
    else
      error_response(@other_user)
    end
  end

  private

  def promotion_params
    params.require(:user).permit(:role)
  end
end
