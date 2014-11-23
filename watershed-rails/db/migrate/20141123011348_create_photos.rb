class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.references :parent, polymorphic: true
      t.string :image

      t.timestamps
    end
  end
end
