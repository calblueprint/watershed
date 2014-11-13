class UserMiniSite < ActiveRecord::Base
  belongs_to :user
  belongs_to :mini_site
end
