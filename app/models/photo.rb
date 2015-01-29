class Photo < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true, counter_cache: true
  mount_uploader :image_name, ImageableUploader

  validate :restrict_number_of_photos, on: :create
  attr_accessor :max_number_of_photos

  default_scope {order('pos ASC')}

  def restrict_number_of_photos
    if self.imageable.photos_count >= self.imageable.class::MAX_PHOTO_ALLOWED
      errors.add(:max_number_of_photos, "Max number of photos reached, this prevent photo from being added")
    end
  end
end
