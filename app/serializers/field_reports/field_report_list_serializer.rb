class FieldReportListSerializer < BaseFieldReportSerializer
  has_one :photo, serializer: PhotoSerializer
end
