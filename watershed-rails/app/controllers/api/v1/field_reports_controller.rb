class Api::V1::FieldReportsController < Api::V1::BaseController
  load_and_authorize_resource param_method: :field_report_params

  def index
    render json: @field_reports, each_serializer: FieldReportListSerializer
  end

  def show
    render json: @field_report, serializer: FieldReportSerializer
  end

  def create
    if @field_report.save
      render json: @field_report, serializer: FieldReportSerializer
    else
      render json: { errors: @field_report.errors }, status: 422
    end
  end

  def update
    if @field_report.update(field_report_params)
      render json: @field_report, serializer: FieldReportSerializer
    else
      render json: { errors: @field_report.errors }, status: 422
    end
  end

  private

  def field_report_params
    params.require(:field_report).permit(:user_id, :mini_site_id,
                                         :description, :health_rating, :urgent,
                                         :task_id, {
                                           photos_attributes: [
                                             :id,
                                             :image,
                                           ],
                                         })
  end
end
