# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  before :cache, :save_original_filename

  def save_original_filename(file)
    model.original_filename ||= file.original_filename if file.respond_to?(:original_filename)
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    "#{Rails.root}/public/tmp/uploads"
  end

  def image?
    image_ext = %w(jpg jpeg gif png)
    if file.respond_to?(:extension)
      image_ext.include?(file.extension.downcase)
    else
      # Not all Carrierwave storages respond to :extension
      ext = file.path.split(".").last.downcase
      image_ext.include?(ext)
    end
  rescue
    false
  end

  def file_storage?
    self.class.storage == CarrierWave::Storage::File
  end

end
