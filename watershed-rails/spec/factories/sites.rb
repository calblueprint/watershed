# == Schema Information
#
# Table name: sites
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  latitude    :decimal(10, 6)
#  longitude   :decimal(10, 6)
#  street      :text
#  city        :string(255)
#  state       :string(255)
#  zip_code    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site do
  end
end
