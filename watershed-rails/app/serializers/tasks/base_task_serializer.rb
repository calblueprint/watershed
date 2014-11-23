class BaseTaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :site_id,
             :complete, :due_date, :urgent

  has_one :assignee, serializer: UserListSerializer
  has_one :assigner, serializer: UserListSerializer
end
