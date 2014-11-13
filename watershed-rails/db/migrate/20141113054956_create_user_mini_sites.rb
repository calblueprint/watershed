class CreateUserMiniSites < ActiveRecord::Migration
  def change
    create_table :user_mini_sites do |t|
      t.references :user
      t.references :mini_site

      t.timestamps
    end
  end
end
