class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :role

  has_many :tasks
  has_many :mini_sites
  has_many :field_reports
end
