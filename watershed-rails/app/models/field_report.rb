# == Schema Information
#
# Table name: field_reports
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  mini_site_id  :integer
#  description   :text
#  health_rating :integer
#  urgent        :boolean          default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#  task_id       :integer
#

class FieldReport < ActiveRecord::Base
  default_scope -> { order("created_at DESC") }

  belongs_to :user
  belongs_to :mini_site
  belongs_to :task

  has_one :photo, as: :parent

  # validates :user_id, presence: true
  # validates :mini_site_id, presence: true
  validates :health_rating, numericality: { less_than_or_equal_to: 5, greater_than_or_equal_to: 1 }

  accepts_nested_attributes_for :photo

  def complete_task
    task.complete
  end
end
