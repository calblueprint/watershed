class Api::V1::Users::TasksController < Api::V1::Users::BaseController
  load_and_authorize_resource through: :user

  def index
    render json: @tasks, each_serializer: TaskListSerializer
  end

end
