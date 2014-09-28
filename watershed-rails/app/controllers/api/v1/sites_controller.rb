class Api::V1::SitesController < Api::V1::BaseController
  load_and_authorize_resource :sites, param_method: :site_params

  def index
  end

  def create
    if @site.save
      # Success
    else
      # Error
    end
  end

  def update
    if @site.update(site_params)
      # Success
    else
      # Error
    end
  end

  private

  def site_params
    params.require(:site).permit(:name, :description, :street,
                                 :city, :state, :zip_code,
                                 :latitude, :longitude)
  end

end
