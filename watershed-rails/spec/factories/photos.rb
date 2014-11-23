# == Schema Information
#
# Table name: photos
#
#  id          :integer          not null, primary key
#  parent_id   :integer
#  parent_type :string(255)
#  image       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :photo do
  end
end
