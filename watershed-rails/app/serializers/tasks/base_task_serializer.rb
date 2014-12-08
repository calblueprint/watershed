class BaseTaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :mini_site_id,
             :complete, :due_date, :urgent, :created_at

  has_one :assignee, serializer: UserListSerializer
  has_one :assigner, serializer: UserListSerializer
end
