class ChangeSiteIdToMiniSiteIdForTasks < ActiveRecord::Migration
  def change
    rename_column :tasks, :site_id, :mini_site_id
  end
end
