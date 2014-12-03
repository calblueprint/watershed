class AddOriginalFilenameToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :original_filename, :string
  end
end
