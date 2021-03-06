class Api::V1::BaseController < Api::BaseController
  before_filter :authenticate_user_from_token!, except: [:ping]
  before_filter :authenticate_api_v1_user!, except: [:ping]

  def mobile
    @user = User.find_by(email: params[:email], authentication_token: params[:auth_token])
    if @user.nil?
      unauthorized_response
    else
      render json: @user, serializer: MobileSerializer
    end
  end

  def ping
    render json: { message: "Successful ping" }
  end

  private

  def current_ability
    @current_ability ||= ::Ability.new(current_api_v1_user)
  end

  def current_user
    current_api_v1_user
  end

  def authenticate_user_from_token!
    user_email = params[:email].presence
    user       = user_email && User.find_by_email(user_email)

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:auth_token])
      # Notice we are passing store false, so the user is not
      # actually stored in the session and a token is needed
      # for every request. If you want the token to work as a
      # sign in token, you can simply remove store: false.
      sign_in user, store: false
    else
      unauthorized_response
    end
  end
end
