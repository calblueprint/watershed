class SiteSerializer < BaseSiteSerializer
  has_many :mini_sites, each_serializer: MiniSitePhotoListSerializer
end
