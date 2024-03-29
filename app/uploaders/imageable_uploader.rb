# encoding: utf-8

class ImageableUploader < Uploader

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

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
    # "/images/fallback/" + [version_name, "default.png"].compact.join('_')
    ActionController::Base.helpers.asset_path("fallback/photo/" + [version_name, "default.png"].compact.join('_'))
  end

  # Process files as they are uploaded:
  process resize_to_fit: [800, 800]

  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:

  version :standard do
    process resize_to_fit: [600, 600]
  end

  version :medium, from_version: :standard do
    process resize_to_fit: [400, 400]
  end

  version :thumb, from_version: :medium do
    process resize_to_fit: [150, 150]
  end

  def manipulate_to width, height
    manipulate! do |img|
      image.resize "#{width}x#{height}"
      img
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   original_filename ? "#{model.imageable_id}-#{original_filename}" : model.id
  # end

end
