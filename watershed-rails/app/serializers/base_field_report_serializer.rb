class BaseFieldReportSerializer < ActiveModel::Serializer
  attributes :user_id, :mini_site_id, :description,
             :health_rating, :urgent
end
