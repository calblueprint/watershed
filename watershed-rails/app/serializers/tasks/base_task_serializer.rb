class BaseTaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :mini_site_id,
             :complete, :due_date, :urgent, :color

  has_one :assignee, serializer: UserListSerializer
  has_one :assigner, serializer: UserListSerializer
end
