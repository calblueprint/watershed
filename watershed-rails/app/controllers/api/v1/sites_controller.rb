class Api::V1::SitesController < Api::V1::BaseController
  load_and_authorize_resource param_method: :site_params

  def index
    render json: @sites
  end

  def show
    render json: @site
  end

  def create
    if @site.save
      render json: @site
    else
      render json: { errors: @site.errors }, status: 422
    end
  end

  def update
    if @site.update(site_params)
      render json: @site
    else
      render json: { errors: @site.errors }, status: 422
    end
  end

  private

  def site_params
    params.require(:site).permit(:name, :description, :street,
                                 :city, :state, :zip_code,
                                 :latitude, :longitude)
  end

end
