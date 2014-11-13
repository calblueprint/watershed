class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :role

  has_many :tasks
  has_many :mini_sites, embed: :ids, include: false
  has_many :field_reports
end
