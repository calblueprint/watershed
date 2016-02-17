class Constants
  COLORS = ["#F44336", "#673AB7", "#03A9F4", "#4CAF50", "#FF5722", "#607D8B",
            "#00BCD4", "#9C27B0", "#E91E63", "#3F51B5", "#009688", "#607D8B"]

  def self.get_color(object)
    COLORS[object.due_date.month]
  end
end
