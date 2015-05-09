class AddDefaultToLatLng < ActiveRecord::Migration
  def change
    change_column :sites, :latitude, precision: 10, scale: 6, default: 0
    change_column :sites, :longitude, precision: 10, scale: 6, default: 0
  end
end
