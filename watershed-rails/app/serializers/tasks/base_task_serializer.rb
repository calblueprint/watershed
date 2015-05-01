class BaseTaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :mini_site_id,
             :complete, :due_date, :urgent, :color, :subscribed

  has_one :assignee, serializer: UserListSerializer
  has_one :assigner, serializer: UserListSerializer

  def subscribed
    !scope.mini_sites.include? object.mini_site
  end
end
