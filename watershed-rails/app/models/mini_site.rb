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
#  planted_at  :date
#

class MiniSite < ActiveRecord::Base
  belongs_to :site

  has_many :field_reports, dependent: :destroy

  has_many :user_mini_sites
  has_many :users, through: :user_mini_sites

  has_many :tasks

  has_many :photos, as: :parent

  # TODO(mark): Make these counts into counter caches
  def tasks_count
    tasks.count
  end

  def field_reports_count
    field_reports.count
  end

  def health_rating
    field_reports.try(:first).try(:health_rating) || 0
  end

end
