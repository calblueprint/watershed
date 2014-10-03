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
#

class FieldReport < ActiveRecord::Base
  belongs_to :user
  belongs_to :mini_site

  validates :user_id, presence: true
  validates :mini_site_id, presence: true
  validates :health_rating, numericality: { less_than_or_equal_to: 5 }

  default_scope -> { order("created_at DESC") }

end
