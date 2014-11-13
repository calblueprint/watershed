# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime
#  updated_at             :datetime
#  name                   :string(255)
#  role                   :integer
#  authentication_token   :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [ :manager, :employee, :community_member ]

  has_many :field_reports
  has_many :assigned_tasks, class_name: "Task", foreign_key: "assigner_id"
  has_many :tasks, class_name: "Task", foreign_key: "assignee_id"

  has_many :user_mini_sites
  has_many :mini_sites, through: :user_mini_sites

  #
  # Mini Sites
  #
  def has_mini_site?(mini_site)
    !user_mini_sites.find_by(mini_site: mini_site).nil?
  end

  def add_mini_site(mini_site)
    unless has_mini_site?(mini_site)
      mini_sites << mini_site
    end
  end

  #
  # Token Authentication
  #
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
      self.save
    end
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless self.class.unscoped.where(authentication_token: token).first
    end
  end
end
