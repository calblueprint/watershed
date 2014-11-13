class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :site_id,
             :complete, :due_date

  #belongs_to :assignee
  #belongs_to :assigner
end
