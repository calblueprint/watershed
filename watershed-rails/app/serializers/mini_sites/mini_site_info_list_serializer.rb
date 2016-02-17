class MiniSiteInfoListSerializer < BaseMiniSiteSerializer
  has_one :site, serializer: SiteInfoListSerializer
end
