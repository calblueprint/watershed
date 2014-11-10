class ActiveRecord::Base

  def to_json
    # Use the active record serializer
    active_model_serializer.new(self).to_json
  end

end

