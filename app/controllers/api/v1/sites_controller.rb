class Api::V1::SitesController < Api::V1::BaseController
  load_and_authorize_resource param_method: :site_params

  def index
    if params[:get_photos]
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

  def create
    if @site.save
      render json: @site, serializer: SiteSerializer
    else
      error_response(@site)
    end
  end

  def update
    if @site.update(site_params)
      render json: @site, serializer: SiteSerializer
    else
      error_response(@site)
    end
  end

  def destroy
    if @site.update(site_params)
      render json: { message: "Deleted site!" }, status: :redirect
    else
      error_response(@site)
    end
  end

  def subscribe
    @site.subscribe(current_user)
    render json: { message: "Subscribed to site!" }, status: :ok
  end

  def unsubscribe
    @site.unsubscribe(current_user)
    render json: { message: "Unsubscribed to site!" }, status: :ok
  end

  private

  def site_params
    params.require(:site).permit(:name, :description, :street,
                                 :city, :state, :zip_code,
                                 :latitude, :longitude)
  end

end
