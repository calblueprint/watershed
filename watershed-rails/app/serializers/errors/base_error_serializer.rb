class BaseErrorSerializer < ActiveModel::Serializer
  attributes :messages

  def messages
    object.full_messages
  end

end
