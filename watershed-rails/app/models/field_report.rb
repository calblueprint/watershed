class FieldReport < ActiveRecord::Base
  belongs_to :user, :mini_site
  validates :user_id, presence: true
  validates :mini_site_id, presence: true
  validates :health_rating, numericality: { less_than_or_equal_to: 5, greater_than_or_equal_to: 5 }

  default_scope -> { order('created_at DESC') }

end
