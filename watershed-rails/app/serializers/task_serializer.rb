class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :site_id,
             :complete, :due_date

  has_one :assignee, embed: :ids, include: false
  has_one :assigner, embed: :ids, include: false
end
