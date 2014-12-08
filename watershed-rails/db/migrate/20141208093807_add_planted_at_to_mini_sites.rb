class AddPlantedAtToMiniSites < ActiveRecord::Migration
  def change
    add_column :mini_sites, :planted_at, :date
  end
end
