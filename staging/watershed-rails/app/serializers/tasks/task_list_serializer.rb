class TaskListSerializer < BaseTaskSerializer
  attributes :assignee_id, :assigner_id

  has_one :mini_site, serializer: BaseMiniSiteSerializer
  has_one :field_report, serializer: BaseFieldReportSerializer
end
