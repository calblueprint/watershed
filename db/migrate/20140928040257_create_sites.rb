class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.text :description
      t.decimal :latitude, { precision: 10, scale: 6 }
      t.decimal :longitude, { precision: 10, scale: 6 }

      # Address
      t.text :street
      t.string :city
      t.string :state
      t.integer :zip_code

      t.timestamps
    end
  end
end
