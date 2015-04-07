class MiniSitePhotoListSerializer < BaseMiniSiteSerializer
  attributes :health_rating

  has_many :photos, each_serializer: PhotoSerializer
end
