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

class Photo < ActiveRecord::Base
end
