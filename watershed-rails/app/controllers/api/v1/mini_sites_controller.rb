class Api::V1::MiniSitesController < Api::V1::BaseController
  load_and_authorize_resource param_method: :mini_site_params

  def index
    render json: @mini_sites
  end

  def show
    render json: @mini_site
  end

  def create
    if @mini_site.save
      render json: @mini_site
    else
      render json: { errors: @mini_site.errors }, status: 422
    end
  end

  def update
    if @mini_site.update(mini_site_params)
      render json: @mini_site
    else
      render json: { errors: @mini_site.errors }, status: 422
    end
  end

  private

  def mini_site_params
    params.require(:mini_site).permit(:id, :name, :description,
                                      :street, :city, :state,
                                      :zip_code, :latitude, :longitude,
                                      :site_id)
  end

end
