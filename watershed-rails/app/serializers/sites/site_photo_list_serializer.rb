class SitePhotoListSerializer < BaseSiteSerializer
  has_many :photos, each_serializer: PhotoSerializer
end
