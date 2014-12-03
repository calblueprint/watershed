class BaseErrorSerializer < ActiveModel::Serializer
  attributes :message

  def message
    full_message
  end

end
