class BaseMiniSiteSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :street, :city,
             :state, :zip_code, :latitude, :longitude,
             :planted_at, :tasks_count, :field_reports_count
end
