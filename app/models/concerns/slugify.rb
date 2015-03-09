module Slugify
  extend ActiveSupport::Concern

  included do
    before_save :set_slug
  end

  def set_slug
    self.slug = title.parameterize
  end

  def to_param
    self.slug
  end

  module ClassMethods
    def by_slug slug_str
      self.find_by(slug: slug_str)
    end
  end
end