class CreateUserSites < ActiveRecord::Migration
  def change
    create_table :user_sites do |t|
      t.timestamps
      t.integer :user_id
      t.integer :site_id
    end
    add_index :user_sites, :user_id
    add_index :user_sites, :site_id
  end
end
