class Error
  include ActiveModel::Model

  def initialize(object, message = nil)
    @object = object
    @message = message
  end

  def message
    @message ||= @object.errors.full_messages.join(" ")
  end

end
