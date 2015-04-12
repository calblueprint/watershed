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
  default_scope -> { order("updated_at DESC") }

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
    Task.joins(:mini_site).where(mini_site: mini_sites)
  end

  def mini_sites_count
    mini_sites.count
  end

  def tasks_count
    tasks.count
  end

  def photos
    # For now, show the first mini_site's photos
    mini_sites.order('id').with_photos.first(6).map { |mini_site| mini_site.photos.first }
  end

  def subscribe(user)
    mini_sites.each { |mini_site| mini_site.users << user }
  end

  def unsubscribe(user)
    mini_sites.each do |mini_site|
      user_mini_site = mini_site.user_mini_sites.find_by(user_id: user.id)
      user_mini_site.destroy unless user_mini_site.blank?
    end
  end
end
