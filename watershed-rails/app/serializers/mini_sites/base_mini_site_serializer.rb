class BaseMiniSiteSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :street, :city,
             :state, :zip_code, :latitude, :longitude,
             :planted_at, :tasks_count, :field_reports_count, :site_id
             :subscribed

  def subscribed
    !scope.mini_sites.find_by(id: object.id).nil?
  end
end
