module Managers
  class MiniSitesController < BaseController
    prepend_before_filter :convert_base64_to_images, only: [:create]
    load_and_authorize_resource param_method: :mini_site_params

    def create
      if @mini_site.save
        render json: @mini_site, serializer: MiniSiteSerializer
      else
        error_response(@mini_site)
      end
    end

    def update
      if @mini_site.update(mini_site_params)
        render json: @mini_site, serializer: MiniSiteSerializer
      else
        error_response(@mini_site)
      end
    end

    def destroy
      if @mini_site.destroy
        render json: @mini_site.site, serializer: SiteSerializer
      else
        error_response(@mini_site)
      end
    end

    private

    def mini_site_params
      params.require(:mini_site).permit(:name, :description,
                                        :street, :city, :state,
                                        :zip_code, :latitude, :longitude,
                                        :site_id, {
                                          photos_attributes: [
                                            :id,
                                            :image,
                                          ],
                                        })
    end

    def convert_base64_to_images
      # TODO(mark): Consider making this a helper function for all models
      unless params[:mini_site][:photos_attributes].blank?
        params[:mini_site][:photos_attributes].each do |attributes|
          attributes[:image] = Photo.convert_base64(attributes[:data])
        end
      end
    end
  end
end
