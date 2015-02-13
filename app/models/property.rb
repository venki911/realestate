class Property < ActiveRecord::Base
  store_accessor :config_features, :story, :floor, :bedroom, :bath_room, :living_room, :dinning_room, :kitchen,
                                   :balcany, :terrace, :garden, :parking

  store_accessor :config_equipments, :bed, :mattress, :cloth, :dressingtable, :cupboard, :dinningtable, :chair,
                                     :sofa, :cabinet, :aircon, :gasstove, :microwave, :refrigerator, :tv, :fanstandingfan,
                                     :satellitedish, :fax, :generator

  store_accessor :config_services, :electricity, :water, :garbage, :security, :pestcontrol, :cabletv, :laundry, :swimmingpool,
                                   :idd, :fax, :newspaper, :credit, :internet

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
  TYPE_SALE_RENT = "Sale+Rent"
  TYPE_PAWN = "Pawn"

  PRICE_PER_SIZE_TOTAL = "Total"
  PRICE_PER_SIZE_M2    = "Meter2"
  PRICE_PER_SIZE_HECTAR = "Hectar"

  PRICE_PER_DURATION_MONTH = "Month"
  PRICE_PER_DURATION_YEAR  = "Year"


  validates :code_ref, uniqueness: true, if: ->(p){p.code_ref.present?}

  validates :width, presence: true, numericality: {greater_than: 0}, unless: ->(p) { p.area.present? }
  validates :length, presence: true, numericality: {greater_than: 0}, unless: ->(p) { p.area.present? }
  validates :area, presence: true, numericality: {greater_than: 0}, if: ->(p) { !p.width.present?  && !p.length.present? }

  validates :province_id, presence: true
  validates :district_id, presence: true
  validates :lat, numericality: true, if: ->(p) { p.lat.present? }
  validates :lng, numericality: true, if: ->(p) { p.lng.present? }

  validates :price_per_unit_sale, presence: true, numericality: {greater_than: 0 }, if: ->(p) { p.type_of != Property::TYPE_RENT }
  validates :price_per_unit_rent, presence: true, numericality: {greater_than: 0 }, if: ->(p) { p.type_of != Property::TYPE_SALE && p.type_of != Property::TYPE_PAWN}

  before_create :generate_code_ref

  def display_id
    "PRT-#{id}"
  end
  def generate_code_ref
    return false if self.code_ref.present?

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
    [ STATUS_NOT_AVAILABLE, STATUS_AVAILABLE ]
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

  def default_thumb_url
    'logo/realestate.png'
  end

end
