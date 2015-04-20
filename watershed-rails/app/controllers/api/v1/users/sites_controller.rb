class Api::V1::Users::SitesController < Api::V1::Users::BaseController
  load_and_authorize_resource through: :user

  def index
    render json: @sites, each_serializer: SiteInfoListSerializer
  end
end
