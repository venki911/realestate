class Photo < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true, counter_cache: true
  mount_uploader :image_name, ImageableUploader
end
