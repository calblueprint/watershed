class AddTaskIdToFieldReports < ActiveRecord::Migration
  def change
    add_column :field_reports, :task_id, :integer
  end
end
