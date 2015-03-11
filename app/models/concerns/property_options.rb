module PropertyOptions
  extend ActiveSupport::Concern

  module ClassMethods
    def available_status
      [ [self::STATUS_AVAILABLE, true], [self::STATUS_NOT_AVAILABLE, false] ]
    end

    def available_price_per_sizes
      [ self::PRICE_PER_SIZE_TOTAL, self::PRICE_PER_SIZE_M2, self::PRICE_PER_SIZE_HECTAR]
    end

    def available_price_per_durations
      [ self::PRICE_PER_DURATION_MONTH, self::PRICE_PER_DURATION_YEAR]
    end

    def available_units
      [self::UNIT_M2, self::UNIT_HECTAR]
    end

    def available_types
      [self::TYPE_RENT, self::TYPE_SALE_RENT, self::TYPE_SALE, self::TYPE_PAWN]
    end

    def available_search_types
      [self::TYPE_RENT, self::TYPE_SALE, self::TYPE_PAWN]
    end

    def admin_verfication_status
      [ self::VERIFICATION_STUTUS_PENDING, self::VERIFICATION_STATUS_OK, self::VERIFICATION_STATUS_REJECT ]
    end
  end
end