module PropertyValidation
  extend ActiveSupport::Concern

  included do
    validates :code_ref, uniqueness: true, if: ->(p){p.code_ref.present?}

    validates :width, presence: true, numericality: {greater_than: 0}, unless: ->(p) { p.area.present? }
    validates :length, presence: true, numericality: {greater_than: 0}, unless: ->(p) { p.area.present? }
    validates :area, presence: true, numericality: {greater_than: 0}

    validates :province_id, presence: true
    validates :district_id, presence: true
    validates :lat, numericality: true, if: ->(p) { p.lat.present? }
    validates :lng, numericality: true, if: ->(p) { p.lng.present? }

    validates :price_per_unit_sale, presence: true, numericality: {greater_than: 0 }, if: ->(p) { p.type_of != Property::TYPE_RENT }
    validates :price_per_unit_rent, presence: true, numericality: {greater_than: 0 }, if: ->(p) { p.type_of != Property::TYPE_SALE && p.type_of != Property::TYPE_PAWN}

    validates :building_area, presence: true, numericality: {greater_than: 0 }, unless: ->(p) { p.category.is_land}
  end
end