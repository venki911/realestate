module PropertyConstant
  extend ActiveSupport::Concern

  included do
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
  end
end