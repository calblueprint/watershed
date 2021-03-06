# == Schema Information
#
# Table name: photos
#
#  id                :integer          not null, primary key
#  parent_id         :integer
#  parent_type       :string(255)
#  image             :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  original_filename :string(255)
#  image_tmp         :string(255)
#  hidden            :boolean          default(FALSE)
#

class Photo < ActiveRecord::Base
  default_scope -> { where(hidden: false).order_most_recent }
  scope :order_most_recent, -> { order("created_at DESC") }

  mount_uploader :image, ImageUploader

  skip_callback :save, :after, :remove_previously_stored_image

  belongs_to :parent, polymorphic: true

  validates :image, presence: true

  def url
    image_tmp_url || image.url
  end

  def image_tmp_url
    "/tmp/uploads/#{image_tmp}" unless image_tmp.nil?
  end

  def self.convert_base64(data)
    return unless data

    temp_file = Tempfile.new [Devise.friendly_token, "jpg"]
    temp_file.binmode
    temp_file.write(Base64.decode64(data))

    ActionDispatch::Http::UploadedFile.new(tempfile: temp_file, filename: "#{Devise.friendly_token}.jpg")
  end

end
