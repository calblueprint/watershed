# == Schema Information
#
# Table name: user_mini_sites
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  mini_site_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_mini_site do
  end
end
