class Api::V1::TasksController < Api::V1::BaseController
  load_and_authorize_resource param_method: :task_params

  def index
    render json: @tasks
  end

  def create
    if @task.save
      render json: @task
    else
      render json: { errors: @task.errors }, status: 422
    end
  end

  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: { errors: @task.errors }, status: 422
    end
  end

  private

  def site_params
    params.require(:task).permit(:title, :description, :site_id,
                                 :assigner_id, :assignee_id, :complete,
                                 :due_date)
  end

end
