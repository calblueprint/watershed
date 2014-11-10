class ActiveRecord::Base

  def serializer
    "#{self.class.name}Serializer".constantize.new(self)
  end

  def to_json
    # Use the active record serializer
    serializer.to_json
  end

end

