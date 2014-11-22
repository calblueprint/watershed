class BaseUserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :role

  def role
    object[:role]
  end

end
