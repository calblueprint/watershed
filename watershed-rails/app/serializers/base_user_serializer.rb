class BaseUserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :role
end
