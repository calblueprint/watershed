class CreateFieldReports < ActiveRecord::Migration
  def change
    create_table :field_reports do |t|
      t.references :user
      t.references :mini_site
      t.integer :health_rating
      t.text :comment
      t.urgent :boolean

      t.timestamps
    end
  end
end
