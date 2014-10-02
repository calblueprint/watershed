class CreateMiniSites < ActiveRecord::Migration
  def change
    create_table :mini_sites do |t|
      t.string :name
      t.text :description
      t.text :street
      t.string :city
      t.string :state
      t.integer :zipcode
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
