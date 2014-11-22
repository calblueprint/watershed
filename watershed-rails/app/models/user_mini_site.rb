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

class UserMiniSite < ActiveRecord::Base
  belongs_to :user
  belongs_to :mini_site
end
