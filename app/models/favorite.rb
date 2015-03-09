class Favorite < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  belongs_to :property, counter_cache: true
end
