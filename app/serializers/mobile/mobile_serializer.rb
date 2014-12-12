class MobileSerializer < ActiveModel::Serializer
  # A mobile serializer is used on a user object
  attributes :task_names

  has_one :user, serializer: UserListSerializer

  def task_names
    Task::DEFAULT_TASK_NAMES
  end

  def user
    object
  end

end
