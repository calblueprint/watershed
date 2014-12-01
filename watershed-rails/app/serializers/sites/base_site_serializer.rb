class BaseSiteSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :street, :city,
             :state, :zip_code, :latitude, :longitude,
             :mini_sites_count

  has_many :photos, serializer: PhotoSerializer
end
