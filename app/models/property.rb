class Property < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  include Bootsy::Container

  store_accessor :config_features, :bedroom, :bathroom, :parking, :livingroom, :dinning_room,:story, :floor,
                                   :kitchen, :balcony, :terrace, :garden, :pool

  store_accessor :config_equipments, :bed, :mattress, :cloth, :dressing_table, :cupboard, :dinning_table, :chair,
                                     :sofa, :cabinet, :aircon, :gas_stove, :microwave, :refrigerator, :tv, :fan, :standing_fan,
                                     :satellite_dish, :fax, :generator, :playground, :water_heater

  store_accessor :config_services, :electricity, :water, :garbage, :security, :pest_control, :cable_tv, :laundry, :gym

  belongs_to :category
  belongs_to :province
  belongs_to :district
  belongs_to :commune
  belongs_to :user, counter_cache: true

  has_many :photos, as: :imageable, dependent: :destroy

  MAX_PHOTO_ALLOWED = 6

  UNIT_HECTAR = "Hectar"
  UNIT_M2     = "Meter2"

  VERIFICATION_STUTUS_PENDING = "Pending"
  VERIFICATION_STATUS_OK = "Verified"
  VERIFICATION_STATUS_REJECT = "Rejected"
  VERIFICATION_STATUS_RESUBMITTED = "Resumitted"

  STATUS_NOT_AVAILABLE = "Not Available"
  STATUS_AVAILABLE = "Available"

  TYPE_SALE = "Sale"
  TYPE_RENT = "Rent"
  TYPE_SALE_RENT = "Sale/Rent"
  TYPE_PAWN = "Pawn"

  PRICE_PER_SIZE_TOTAL = "Total"
  PRICE_PER_SIZE_M2    = "Meter2"
  PRICE_PER_SIZE_HECTAR = "Hectar"

  PRICE_PER_DURATION_MONTH = "Month"
  PRICE_PER_DURATION_YEAR  = "Year"

  PREFIX_ID = "PPN"

  FACILITY_BOOL = "&#10003"

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

  before_create :generate_code_ref
  before_save :calculate_total_price

  attr_accessor :features_list

  def self.search options
    properties = where("1=1")
    properties = properties.where(["user_id = ? ", options[:user_id] ]) if options[:user_id].present?
    properties = properties.where(mark_as_featured: true) if options[:featured].present?
    if options[:ref].present?
      param_id = Property::id_without_prefix(options[:ref])
      properties = properties.where(["(code_ref = ? OR id = ? )", options[:ref], param_id.to_i]) unless param_id.blank?
    end
    properties
  end

  def toggle_status
    self.status = !self.status
    self.save
  end

  def toggle_featured
    self.mark_as_featured = !self.mark_as_featured
    self.save
  end

  def toggle_urgent
    self.mark_as_urgent = !self.mark_as_urgent
    self.save
  end
  
  def toggle_exclusive
    self.mark_as_exclusive = !self.mark_as_exclusive
    self.save
  end

  def toggle_blocked
    self.mark_as_blocked = !self.mark_as_blocked
    self.save
  end

  def self.config_attr_type attr
    quantity_types = [:bedroom, :bathroom, :parking, :livingroom, :dinning_room,:story, :floor,
     :bed, :mattress, :cloth, :dressing_table, :cupboard, :dinning_table, :chair, :sofa, :cabinet,
     :aircon, :gas_stove, :microwave, :refrigerator, :tv, :fan,
     :standing_fan, :electricity, :water, :garbage, :security, :pest_control, :cable_tv, :laundry, :gym]
    quantity_types.include?(attr) ? :numeric : :boolean
  end

  def calculate_total_price
    calculate_and_set_total_price_sale
    calculate_and_set_total_price_rent
  end

  def id_with_prefix
    "#{Property::PREFIX_ID}-#{id}"
  end

  def self.id_without_prefix(id_pattern)
    pattern = "#{Property::PREFIX_ID}-?"
    id_pattern.sub(/#{pattern}/i, "")
  end

  def has_map?
    self.lat.present? && self.lng.present? && self.show_on_map?
  end

  def special?
    self.mark_as_urgent || self.mark_as_exclusive
  end

  def self.listing
    where([ 'verification_status = ? AND mark_as_blocked = ? AND mark_as_featured = ? AND status = ?',
            Property::VERIFICATION_STATUS_OK, false, false, true ])
  end

  def self.featured_listing
    where([ 'verification_status = ? AND mark_as_blocked = ? AND mark_as_featured = ? AND status = ?',
            Property::VERIFICATION_STATUS_OK, false, true, true ])
  end

  def generate_code_ref
    return true if self.code_ref.present?

    self.code_ref = loop do
      random_code = SecureRandom.urlsafe_base64(6)
      if self.class.exists?(code_ref: code_ref)
        warn "Possibly duplicate generated token"
      else
        break random_code
      end
    end
  end

  def rejected?
    verification_status == Property::VERIFICATION_STATUS_REJECT
  end

  def over_quota?
    photos_count >= Property::MAX_PHOTO_ALLOWED
  end

  def resume_rejected!
    if verification_status == VERIFICATION_STATUS_REJECT
      self.verification_status = VERIFICATION_STATUS_RESUBMITTED
    end
  end

  def self.avalable_status
    [ [STATUS_AVAILABLE, true], [STATUS_NOT_AVAILABLE, false] ]
  end

  def self.available_price_per_sizes
    [PRICE_PER_SIZE_TOTAL, PRICE_PER_SIZE_M2, PRICE_PER_SIZE_HECTAR]
  end

  def self.available_price_per_durations
    [PRICE_PER_DURATION_MONTH, PRICE_PER_DURATION_YEAR]
  end

  def self.available_units
    [UNIT_M2, UNIT_HECTAR]
  end

  def self.available_types
    [TYPE_RENT, TYPE_SALE_RENT, TYPE_SALE, TYPE_PAWN]
  end

  def self.admin_verfication_status
    [ VERIFICATION_STUTUS_PENDING, VERIFICATION_STATUS_OK, VERIFICATION_STATUS_REJECT ]
  end

  def logo
    photos_count > 0 ? photos.first.image_name.thumb.url : default_thumb_url
  end

  def building_size?
    building_width.present? && building_length.present? && building_area.present?
  end

  def title
    result = borey_name.present? ? "#{borey_name} #{category.name} " : category.name
    "#{result} for #{type_of}"
  end

  def location
    result = [] 
    result << commune.name if commune
    result << district.name if district
    result << province.name if province
    result.join(", ")
  end

  def to_param
    "#{id_with_prefix} #{self.title}-in-#{province.name}".parameterize
  end

  def self.find_by_url param_id
    length = Property::PREFIX_ID.length + 1
    id = param_id[length..-1]
    find(id)
  end

  def marked_items
    result = []
    result << 'Urgent' if self.mark_as_urgent
    result << 'Exclusive' if self.mark_as_exclusive
    result
  end

  def features_list
    return @features_list if @features_list
    boolean_attr = [ :kitchen, :balcony, :terrace, :garden, :pool, :satellite_dish, :fax, :generator, :playground, :water_heater,
                     :electricity, :water, :garbage, :security, :pest_control, :cable_tv, :laundry, :gym ]

    config_attrs = Property.stored_attributes[:config_features] + Property.stored_attributes[:config_equipments] + Property.stored_attributes[:config_services]
    @features_list = features_list_for(config_attrs)
    @features_list
  end

  def features_list_for(config_attrs)
    boolean_attr = [ :kitchen, :balcony, :terrace, :garden, :pool, :satellite_dish, :fax, :generator, :playground, :water_heater,
                     :electricity, :water, :garbage, :security, :pest_control, :cable_tv, :laundry, :gym ]

    results = {}
    config_attrs.each do |attr|
      value = self.send(attr)
      if value.to_i != 0
        if boolean_attr.include?(attr)
          results[attr] = Property::FACILITY_BOOL
        else
          results[attr] = value
        end
      end
    end
    results
  end

  private
  def default_thumb_url
    'logo/realestate.png'
  end

    def area_in_m2
    self.unit == Property::UNIT_M2 ? self.area : (self.area * 10000)
  end

  def area_in_hectar
    self.unit == Property::UNIT_M2 ? (self.area/10000) : self.area
  end

  def calculate_and_set_total_price_rent
    if self.type_of == Property::TYPE_RENT || self.type_of == Property::TYPE_SALE_RENT
      if self.price_per_size_rent == Property::PRICE_PER_SIZE_TOTAL
        self.total_price_rent = self.price_per_unit_rent
      elsif self.price_per_size_rent == Property::PRICE_PER_SIZE_M2
        self.total_price_rent = self.price_per_unit_rent * area_in_m2
      elsif self.price_per_size_rent == Property::PRICE_PER_SIZE_HECTAR
        self.total_price_rent = self.price_per_unit_rent * area_in_hectar
      end
    end
  end

  def calculate_and_set_total_price_sale
    if self.type_of != Property::TYPE_RENT
      if self.price_per_size_sale == Property::PRICE_PER_SIZE_TOTAL
        self.total_price_sale = self.price_per_unit_sale
      elsif self.price_per_size_sale == Property::PRICE_PER_SIZE_M2
        self.total_price_sale = self.price_per_unit_sale * area_in_m2
      elsif self.price_per_size_sale == Property::PRICE_PER_SIZE_HECTAR
        self.total_price_sale = self.price_per_unit_sale * area_in_hectar
      end
    end
  end

end
