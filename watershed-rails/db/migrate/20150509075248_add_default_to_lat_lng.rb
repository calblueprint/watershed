class AddDefaultToLatLng < ActiveRecord::Migration
  def change
    change_column :sites, :latitude, :decimal, precision: 10, scale: 6, default: 0.0
    change_column :sites, :longitude, :decimal, precision: 10, scale: 6, default: 0.0
  end
end
