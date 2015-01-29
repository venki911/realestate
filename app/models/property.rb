class Property < ActiveRecord::Base
  belongs_to :category
  belongs_to :province
  belongs_to :district
  belongs_to :commune
  belongs_to :user, counter_cache: true

  has_many :photos, as: :imageable, dependent: :destroy

  MAX_PHOTO_ALLOWED = 4

  UNIT_HECTAR = "Hectar"
  UNIT_M2     = "M2"

  VERIFICATION_STUTUS_PENDING = "Pending"
  VERIFICATION_STATUS_OK = "Verified"
  VERIFICATION_STATUS_REJECT = "Rejected"
  VERIFICATION_STATUS_RESUBMITTED = "Resumitted"

  STATUS_NOT_AVAILABLE = "Not Available"
  STATUS_AVAILABLE = "Available"

  TYPE_SALE = "Sale"
  TYPE_RENT = "Rent"
  TYPE_PAWN = "Pawn"

  PRICE_PER_SIZE_TOTAL = "Total"
  PRICE_PER_SIZE_M2    = "M2"
  PRICE_PER_SIZE_HECTAR = "Hectar"

  PRICE_PER_DURATION_MONTH = "Month"
  PRICE_PER_DURATION_YEAR  = "Year"

  validates :code_ref, uniqueness: true, if: ->(p){p.code_ref.present?}
  validates :price_per_unit, presence: true, numericality: {greater_than: 0}

  validates :width, presence: true, numericality: {greater_than: 0}, unless: ->(p) { p.area.present? }
  validates :length, presence: true, numericality: {greater_than: 0}, unless: ->(p) { p.area.present? }
  validates :area, presence: true, numericality: {greater_than: 0}, if: ->(p) { !p.width.present?  && !p.length.present? }
  validates :province_id, presence: true

  before_create :generate_code_ref

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

  def over_quota?
    photos_count >= Property::MAX_PHOTO_ALLOWED
  end

  def resume_rejected!
    if verification_status == VERIFICATION_STATUS_REJECT
      self.verification_status = VERIFICATION_STATUS_RESUBMITTED
    end
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

  def self.available_boreys
    ["New world", "Penghourt"]
  end

  def self.available_types
    [TYPE_SALE, TYPE_RENT, TYPE_PAWN]
  end

end
