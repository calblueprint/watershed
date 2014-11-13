class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :site_id,
             :complete, :due_date

  has_one :assignee
  has_one :assigner
end
