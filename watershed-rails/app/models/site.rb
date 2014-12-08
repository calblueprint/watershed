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

class Site < ActiveRecord::Base
  has_many :mini_sites

  #
  # Search
  #
  include PgSearch
  pg_search_scope :search,
                  against: [[:name, "A"], [:street, "B"], [:city, "B"], [:state, "B"], [:zip_code, "B"]],
                  using: { tsearch: { prefix: true, normalization: 2 } }

  #
  # Properties
  #
  def tasks
    mini_sites.joins(:tasks).collect { |mini_site| mini_site.tasks }.flatten
  end

  def mini_sites_count
    mini_sites.count
  end

  def tasks_count
    tasks.count
  end

  def photos
    # For now, show the first photo of the first mini site
    # Has to return an array, thus the try(:first, 1)
    mini_sites.try(:first).try(:photos).try(:first, 1) || []
  end

end
