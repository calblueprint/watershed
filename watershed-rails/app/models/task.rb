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
#  complete     :boolean          default(FALSE)
#  due_date     :datetime
#  created_at   :datetime
#  updated_at   :datetime
#  urgent       :boolean          default(FALSE)
#  color        :string(255)
#

class Task < ActiveRecord::Base
  default_scope -> { where("created_at < :date", date: 4.weeks.ago).order("updated_at DESC") }
  scope :unassigned, -> { where("assignee_id IS NULL") }
  scope :completed, -> { where(complete: true) }
  scope :for_mini_sites, -> (mini_sites) { where(mini_site: mini_sites) }

  DEFAULT_TASK_NAMES = [
                         "Water",
                         "Prune",
                         "Weed",
                         "Clear Inlet/Outlet",
                         "Re-Plant",
                         "Hardware Fix",
                         "Outreach",
                       ]

  NEW_TASK = "new_task"
  NEW_UNASSIGNED_TASK = "new_unassigned_task"

  belongs_to :assigner, class_name: "User", foreign_key: "assigner_id"
  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id"
  belongs_to :mini_site

  has_one :field_report

  before_create :add_color

  validates :title, presence: true
  validates :description, presence: true
  validates :mini_site_id, presence: true
  validates :assigner_id, presence: true
  validates :due_date, presence: true
  validates :urgent, presence: true

  def send_notifications
    if assignee.blank?
      SendNotificationJob.new.async.perform(mini_site.site.users, NEW_UNASSIGNED_TASK, self)
    else
      SendNotificationJob.new.async.perform([assignee], NEW_TASK, self)
    end
  end

  def complete!
    update_attribute(:complete, true)
  end

  def undo_complete!
    update_attribute(:complete, false)
  end

  private

  def add_color
    self.color = Constants.get_color self
  end
end
