class SiteSerializer < BaseSiteSerializer
  has_many :mini_sites, each_serializer: MiniSitePhotoListSerializer
  has_many :photos, each_serializer: PhotoSerializer
end
