# frozen_string_literal: true

class PhotoUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  include CarrierWave::Processing::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    # ActionController::Base.helpers
    #   .asset_path("fallback/" +
    #               [version_name, "default.png"].compact.join('_'))

    return if model.is_a?(Post)
 
    "https://storage.googleapis.com/pin-app-production/default.jpeg"
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # process convert: 'jpg'
  # process colorspace: :rgb
  # process quality: 90

  version :thumb do
    process resize_and_crop: 128
  end

  version :normal do
    process resize_and_crop: 512
  end

  private

  def crop(geometry)
    manipulate! do |img|
      img.crop(geometry)
      img
    end
  end

  def resize_and_crop(size)
    manipulate! do |image|
      if width_smaller?(image)
        image.shave(height_shave_size(image))
      elsif height_smaller?(image)
        image.shave(width_shave_size(image))
      end

      image.tap { |img| img.resize("#{size}x#{size}") }
    end
  end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w[svg jpg jpeg gif png]
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here,
  #   see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  def width_smaller?(image)
    image[:width] < image[:height]
  end

  def height_smaller?(image)
    image[:width] > image[:height]
  end

  def width_shave_size(image)
    remove = ((image[:width] - image[:height]) / 2).round
    "#{remove}x0"
  end

  def height_shave_size(image)
    remove = ((image[:height] - image[:width]) / 2).round
    "0x#{remove}"
  end
end
