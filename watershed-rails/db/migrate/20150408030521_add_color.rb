class AddColor < ActiveRecord::Migration
  def change
    add_column :tasks, :color, :string
  end
end
