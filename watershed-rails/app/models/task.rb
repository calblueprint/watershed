# == Schema Information
#
# Table name: tasks
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  description  :text
#  mini_site_id :integer
#  assigner_id  :integer
#  assignee_id  :integer
#  complete     :boolean
#  due_date     :datetime
#  created_at   :datetime
#  updated_at   :datetime
#  urgent       :boolean          default(FALSE)
#

class Task < ActiveRecord::Base

  DEFAULT_TASK_NAMES = [
    "Water",
    "Prune",
    "Weed",
    "Clear Inlet/Outlet",
    "Re-Plant",
    "Hardware Fix",
    "Outreach",
  ]

  belongs_to :assigner, class_name: "User", foreign_key: "assigner_id"
  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id"
  belongs_to :mini_site

  has_one :field_report
end
