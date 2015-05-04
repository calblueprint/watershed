class Api::V1::TasksController < Api::V1::BaseController
  load_and_authorize_resource

  def index
    render json: @tasks, each_serializer: TaskListSerializer
  end

  def show
    render json: @task, serializer: TaskSerializer
  end

  def claim
    if @task.claim(current_user)
      render json: @task, serializer: TaskSerializer
    else
      error_response(@task, "This task has already been assigned!")
    end
  end
end
