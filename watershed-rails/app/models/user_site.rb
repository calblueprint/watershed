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

class UserSite < ActiveRecord::Base
  belongs_to :user
  belongs_to :site
end
