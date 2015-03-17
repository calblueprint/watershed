class AddDefaultValueToTask < ActiveRecord::Migration
  def change
    change_column :tasks, :complete, :boolean, default: false
  end
end
