class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :site_id,
             :complete, :due_date

  belongs_to :assignee, class_name: "User"
  belongs_to :assigner, class_name: "User"
end
