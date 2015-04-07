class UserSerializer < BaseUserSerializer
  # has_many :tasks
  # has_many :mini_sites
  # has_many :field_reports

  attributes :tasks_count, :mini_sites_count, :field_reports_count

  def tasks_count
    object.tasks.count
  end

  def mini_sites_count
    object.mini_sites.count
  end

  def field_reports_count
    object.field_reports.count
  end

end
