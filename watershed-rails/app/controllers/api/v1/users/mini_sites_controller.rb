class Api::V1::Users::MiniSitesController < Api::V1::Users::BaseController
  load_and_authorize_resource

  def index
    render json: @mini_sites, each_serializer: MiniSiteListSerializer
  end

end
