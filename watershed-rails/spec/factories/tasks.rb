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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
  end
end
