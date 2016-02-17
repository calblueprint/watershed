class Api::V1::SitesController < Api::V1::BaseController
  load_and_authorize_resource

  def index
    if params[:get_photos] == "true"
      render json: @sites, each_serializer: SitePhotoListSerializer
    else
      render json: @sites, each_serializer: SiteInfoListSerializer
    end
  end

  def show
    render json: @site, serializer: SiteSerializer
  end

  def search
    @sites = @sites.search(params[:q])
    render json: @sites, each_serializer: SitePhotoListSerializer
  end

  def subscribe
    if @site.subscribe(current_user)
      render json: { message: "Subscribed to site!" }, status: :ok
    else
      error_response(@site, "You can't subscribe to this site!")
    end
  end

  def unsubscribe
    if @site.unsubscribe(current_user)
      render json: { message: "Unsubscribed to site!" }, status: :ok
    else
      error_response(@site, "You can't unsubscribe to this site!")
    end
  end
end
