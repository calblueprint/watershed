class BasePhotoSerializer < ActiveModel::Serializer
  attributes :id, :url, :created_at
end
