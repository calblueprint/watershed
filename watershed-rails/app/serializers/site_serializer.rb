class SiteSerializer < ActiveModel::Serializer
  attributes :name, :description, :street, :city, :state,
             :zip_code, :latitude, :longitude

  # TODO(mark): When we add MiniSite(s), we need to add a relationship here:
  # has_many :mini_sites
end
