class Property < ActiveRecord::Base
  belongs_to :category
  belongs_to :province
  belongs_to :district
  belongs_to :commune
  belongs_to :user

  UNIT_HECTAR = "ha"
  UNIT_M2     = "m2"

  VERIFICATION_STUTUS_PENDING = "Pending"
  VERIFICATION_STATUS_OK = "Ok"
  VERIFICATION_STATUS_REJECT = "Reject"

  STATUS_NOT_AVAILABLE = "Not Available"
  STATUS_AVAILABLE = "Available"

  TYPE_RENT = "Rent"
  TYPE_SALE = "Sale"
  TYPE_PAWN = "Pawn"
  TYPE_RENT_SALE = "Rent/Sale"

  def self.available_units
    [UNIT_M2, UNIT_HECTAR]
  end

  def self.available_boreys
    ["New world", "Penghourt"]
  end

  def self.available_types
    [TYPE_RENT, TYPE_SALE, TYPE_RENT_SALE, TYPE_PAWN]
  end

end
