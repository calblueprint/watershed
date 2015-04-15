# == Schema Information
#
# Table name: user_sites
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  site_id    :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_site, :class => 'UserSites' do
    user_id 1
    site_id 1
  end
end
