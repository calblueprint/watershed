# == Schema Information
#
# Table name: mini_sites
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  street      :text
#  city        :string(255)
#  state       :string(255)
#  zip_code    :integer
#  latitude    :decimal(, )
#  longitude   :decimal(, )
#  created_at  :datetime
#  updated_at  :datetime
#  site_id     :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mini_site do
    name "MyString"
    description "MyText"
    street "MyText"
    city "MyString"
    state "MyString"
    zipcode 1
    latitude "9.99"
    longitude "9.99"
  end
end
