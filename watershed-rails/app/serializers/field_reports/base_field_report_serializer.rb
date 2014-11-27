class BaseFieldReportSerializer < ActiveModel::Serializer
  attributes :user_id, :mini_site_id, :task_id,
             :description, :health_rating, :urgent
end
