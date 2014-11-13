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

class MiniSite < ActiveRecord::Base
  belongs_to :site

  has_many :field_reports, dependent: :destroy

  has_many :user_mini_sites
  has_many :users, through: :user_mini_sites
end
