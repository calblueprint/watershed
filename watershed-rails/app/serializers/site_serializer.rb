class SiteSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :street, :city,
             :state, :zip_code, :latitude, :longitude

  has_many :mini_sites, embed: :ids, include: false
end
