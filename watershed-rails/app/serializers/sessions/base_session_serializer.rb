class BaseSessionSerializer < ActiveModel::Serializer
  # A session serializer is used on a user object
  attributes :email, :authentication_token
end
