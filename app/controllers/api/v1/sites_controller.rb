class Api::V1::SitesController < Api::V1::BaseController
  load_and_authorize_resource param_method: :site_params

  def index
    render json: @sites, each_serializer: SiteListSerializer
  end

  def show
    render json: @site, serializer: SiteSerializer
  end

  def search
    @sites = @sites.search(params[:q])
    render json: @sites, each_serializer: SiteListSerializer
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

  private

  def site_params
    params.require(:site).permit(:name, :description, :street,
                                 :city, :state, :zip_code,
                                 :latitude, :longitude)
  end

end
