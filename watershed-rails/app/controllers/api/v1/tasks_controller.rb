class Api::V1::TasksController < Api::V1::BaseController
  load_and_authorize_resource param_method: :task_params

  def index
    @tasks = @tasks.unassigned.for_mini_sites(current_api_v1_user.mini_sites)
    render json: @tasks, each_serializer: TaskListSerializer
  end

  def show
    render json: @task, serializer: TaskSerializer
  end

  def create
    if @task.save
      render json: @task, serializer: TaskSerializer
    else
      error_response(@task)
    end
  end

  def update
    if @task.update(task_params)
      render json: @task, serializer: TaskSerializer
    else
      error_response(@task)
    end
  end

  private

  def site_params
    params.require(:task).permit(:title, :description, :site_id,
                                 :assigner_id, :assignee_id, :complete,
                                 :due_date)
  end

end
