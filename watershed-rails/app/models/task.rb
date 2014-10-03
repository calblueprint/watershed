# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  site_id     :integer
#  assigner_id :integer
#  assignee_id :integer
#  complete    :boolean
#  due_date    :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

class Task < ActiveRecord::Base
  belongs_to :assigner, :class_name => 'User', :foreign_key => 'assigner_id'
  belongs_to :assignee, :class_name => 'User', :foreign_key => 'assignee_id'
end
