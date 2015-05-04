class Api::V1::FieldReportsController < Api::V1::BaseController
  prepend_before_filter :convert_base64_to_image, only: [:create]
  load_and_authorize_resource

  def index
    render json: @field_reports, each_serializer: FieldReportListSerializer
  end

  def show
    render json: @field_report, serializer: FieldReportSerializer
  end

  def create
    if @field_report.save
      @field_report.complete_task
      render json: @field_report, serializer: FieldReportSerializer
    else
      error_response(@field_report)
    end
  end

  def update
    if @field_report.update(field_report_params)
      render json: @field_report, serializer: FieldReportSerializer
    else
      error_response(@field_report)
    end
  end

  private

  def field_report_params
    params.require(:field_report).permit(:user_id, :mini_site_id,
                                         :description, :health_rating, :urgent,
                                         :task_id, {
                                           photo_attributes: [
                                             :id,
                                             :image,
                                           ],
                                         })
  end

  def convert_base64_to_image
    unless params[:field_report][:photo_attributes].blank?
      params[:field_report][:photo_attributes][:image] = Photo.convert_base64(params[:field_report][:photo_attributes][:data])
    end
  end

end
