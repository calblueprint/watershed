class BaseTaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :site_id,
             :complete, :due_date

  has_one :assignee, serializer: UserListSerializer
  has_one :assigner, serializer: UserListSerializer
end
