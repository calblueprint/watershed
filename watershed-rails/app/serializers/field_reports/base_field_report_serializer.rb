class BaseFieldReportSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :mini_site_id, :task_id,
             :description, :health_rating, :urgent
end
