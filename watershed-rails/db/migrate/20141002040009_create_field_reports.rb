class CreateFieldReports < ActiveRecord::Migration
  def change
    create_table :field_reports do |t|
      t.references :user
      t.references :mini_site
      t.text :description
      t.integer :health_rating
      t.boolean :urgent, default: false

      t.timestamps
    end
  end
end
