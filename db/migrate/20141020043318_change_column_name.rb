class ChangeColumnName < ActiveRecord::Migration
  def change
  	rename_column :mini_sites, :zipcode, :zip_code
  end
end
