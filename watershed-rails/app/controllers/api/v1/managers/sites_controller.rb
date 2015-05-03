class Api::V1::SitesController < BaseController
  load_and_authorize_resource param_method: :site_params

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
    if @site.destroy
      render json: { message: "Deleted site!" }, status: :ok
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
