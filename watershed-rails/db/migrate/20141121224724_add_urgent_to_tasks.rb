class AddUrgentToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :urgent, :boolean, default: false
  end
end
