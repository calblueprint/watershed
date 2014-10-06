class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :site_id
      t.integer :assigner_id
      t.integer :assignee_id
      t.boolean :complete
      t.datetime :due_date

      t.timestamps
    end
  end
end
