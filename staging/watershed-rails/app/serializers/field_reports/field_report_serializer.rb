class FieldReportSerializer < BaseFieldReportSerializer
  has_one :user,      serializer: UserListSerializer
  has_one :mini_site, serializer: MiniSitePhotoListSerializer
  has_one :task,      serializer: TaskListSerializer

  has_one :photo,     serializer: PhotoSerializer
end
