class AddSiteIdToMiniSite < ActiveRecord::Migration
	def change
		add_column :mini_sites, :site_id, :integer
	end
end
