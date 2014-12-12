class TaskSerializer < BaseTaskSerializer
  has_one :field_report, serializer: FieldReportListSerializer
end
