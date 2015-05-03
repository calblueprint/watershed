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
#  role                   :integer          default(0)
#  authentication_token   :string(255)
#  facebook_auth_token    :text
#  facebook_id            :string(255)
#  registration_id        :string(255)
#  device_type            :integer
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [ :community_member, :employee, :manager ]
  enum device_type: [ :android, :ios ]

  has_many :field_reports
  has_many :assigned_tasks, class_name: "Task", foreign_key: "assigner_id"
  has_many :tasks, class_name: "Task", foreign_key: "assignee_id"

  has_many :user_mini_sites
  has_many :mini_sites, through: :user_mini_sites

  has_many :user_sites
  has_many :sites, through: :user_sites

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  #
  # Search
  #
  include PgSearch
  pg_search_scope :search,
                  against: [[:name, "A"], [:email, "A"], [:role, "B"]],
                  using: { tsearch: { prefix: true, normalization: 2 } }

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
    if authentication_token.nil? || authentication_token.blank?
      self.authentication_token = generate_authentication_token
      self.save
    end
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      return token unless self.class.unscoped.where(authentication_token: token).first
    end
  end

  #
  # Facebook Authentication
  #
  def valid_facebook_token?(token)
    !facebook_auth_token.blank? && facebook_auth_token == token
  end

  def create_with_facebook_info(facebook_params)
    if facebook_params[:facebook_auth_token].nil?
      return false
    end

    self.name = facebook_params[:name]
    self.facebook_auth_token = facebook_params[:facebook_auth_token]
    self.facebook_id = facebook_params[:facebook_id]
    self.password = Devise.friendly_token

    # TODO(mark): More configuration with the facebook params (photo, etc)
    self.save
  end
end
