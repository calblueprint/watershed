class AddHiddenToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :hidden, :boolean, default: false
  end
end
