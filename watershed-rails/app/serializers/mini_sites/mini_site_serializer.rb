class MiniSiteSerializer < BaseMiniSiteSerializer
  has_many :field_reports, each_serializer: FieldReportListSerializer
  has_many :photos, each_serializer: PhotoSerializer

  # has_many :users
end
