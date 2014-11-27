class AddImageTmpToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :image_tmp, :string
  end
end
