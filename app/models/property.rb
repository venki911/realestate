class Property < ActiveRecord::Base
  belongs_to :category
  belongs_to :province
  belongs_to :district
  belongs_to :commune
  belongs_to :user

  has_many :photos, as: :imageable, dependent: :destroy

  UNIT_HECTAR = "Hectar"
  UNIT_M2     = "M2"

  VERIFICATION_STUTUS_PENDING = "Pending"
  VERIFICATION_STATUS_OK = "Ok"
  VERIFICATION_STATUS_REJECT = "Reject"

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

  validates :price_per_unit, presence: true, numericality: {greater_than: 0}

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
