class BaseUserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :role, :created_at, :registration_id

  def role
    object[:role]
  end

end
