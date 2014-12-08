class BaseUserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :role, :created_at

  def role
    object[:role]
  end

end
