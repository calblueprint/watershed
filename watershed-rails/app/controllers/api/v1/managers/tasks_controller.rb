class Api::V1::TasksController < Api::V1::BaseController
  load_and_authorize_resource param_method: :task_params

  def create
    if @task.save
      @task.send_notifications
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

  def destroy
    if @task.destroy
      render json: Task.all, each_serializer: TaskListSerializer
    else
      error_response(@task)
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :mini_site_id,
                                 :assigner_id, :assignee_id, :complete,
                                 :due_date, :urgent)
  end

end
