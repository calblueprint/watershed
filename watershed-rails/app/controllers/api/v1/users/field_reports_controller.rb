class Api::V1::Users::FieldReportsController < Api::V1::Users::BaseController
  load_and_authorize_resource

  def index
    render json: @field_reports, each_serializer: FieldReportListSerializer
  end

end
