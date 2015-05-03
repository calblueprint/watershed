class Api::V1::MiniSitesController < Api::V1::BaseController
  load_and_authorize_resource

  def index
    if params[:get_photos]
      render json: @mini_sites, each_serializer: MiniSitePhotoListSerializer
    else
      render json: @mini_sites, each_serializer: MiniSiteInfoListSerializer
    end

  end

  def show
    render json: @mini_site, serializer: MiniSiteSerializer
  end
end
