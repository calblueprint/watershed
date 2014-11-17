class MiniSiteSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :street, :city,
             :state, :zip_code, :latitude, :longitude

  # has_one :site
  # has_many :users
  # has_many :field_reports
end
