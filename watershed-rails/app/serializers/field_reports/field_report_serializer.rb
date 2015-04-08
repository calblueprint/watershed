class FieldReportSerializer < BaseFieldReportSerializer
  has_one :user,      serializer: BaseUserSerializer
  has_one :mini_site, serializer: BaseMiniSiteSerializer
  has_one :task,      serializer: BaseTaskSerializer

  has_one :photo,     serializer: PhotoSerializer
end
