# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_site, :class => 'UserSites' do
    user_id 1
    site_id 1
  end
end
