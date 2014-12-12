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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :field_report do
  end
end
