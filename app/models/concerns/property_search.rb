module PropertySearch
  extend ActiveSupport::Concern

  module ClassMethods
    def search options
      properties = where("true")
      properties = properties.where(["user_id = ? ", options[:user_id] ]) if options[:user_id].present?
      properties = properties.where(mark_as_featured: true) if options[:featured].present?
      properties = properties.where(['category_id = ?', options[:category_id] ]) unless options[:category_id].blank?

      properties = properties.by_type(options[:type])

      properties = properties.by_ref(options[:ref])
      properties = properties.by_borey_name(options[:borey_name])
      properties = properties.area_between(options[:min_area], options[:max_area], options[:category_id])
      properties = properties.price_between(options[:min_price], options[:max_price], options[:type])
      properties = properties.in_location(options[:province_id], options[:district_id])

      properties
    end

    def by_borey_name(borey_name)
      properties = where("true")
      if !borey_name.blank?
        properties = properties.where(["borey_name = ?", borey_name])
      end
      properties
    end

    def by_type(type)
      properties = where("true")
      if !type.blank?
        if type == Property::TYPE_RENT
          properties = properties.where(['type_of = ? OR type_of = ? ', Property::TYPE_RENT, Property::TYPE_SALE_RENT])
        elsif type == Property::TYPE_SALE
          properties = properties.where(['type_of = ? OR type_of = ? ', Property::TYPE_SALE, Property::TYPE_SALE_RENT])
        else
          properties = properties.where(['type_of = ?', type])
        end
      end
      properties
    end

    def by_ref ref
      properties = where("true")
      if !ref.blank?
        param_id = Property::id_without_prefix(ref)
        properties = where(["(code_ref = ? OR id = ? )", ref, param_id.to_i]) unless param_id.blank?
      end
      properties
    end

    def area_between min_area, max_area, category_id=nil
      properties = where("true")
      category = Category.find_by(id: category_id.to_i)

      if category && !category.is_land
        properties = properties.where(["building_area >= ?", min_area ]) unless min_area.blank?
        properties = properties.where(["building_area <= ?", max_area ]) unless max_area.blank?
      else
        properties = properties.where(["area >= ?", min_area ]) unless min_area.blank?
        properties = properties.where(["area <= ?", max_area ]) unless max_area.blank?
      end
      properties
    end

    def price_between min_price, max_price, type = Property::TYPE_RENT
      properties = where("true")
      if type == Property::TYPE_RENT
        properties = properties.where(['total_price_rent >= ?', min_price ]) unless min_price.blank?
        properties = properties.where(['total_price_rent <= ?', max_price ]) unless max_price.blank?
      else
        properties = properties.where(['total_price_sale >= ?', min_price ]) unless min_price.blank?
        properties = properties.where(['total_price_sale <= ?', max_price ]) unless max_price.blank?
      end
      properties
    end

    def in_location province_id, district_id
      properties = where("true")
      if(!district_id.blank?)
        properties = properties.where(['district_id = ?', district_id ])
      elsif(!province_id.blank?)
        properties = properties.where(['province_id = ?', province_id ])
      end
      properties
    end

    def listing
      where([ 'verification_status = ? AND mark_as_blocked = ? AND mark_as_featured = ? AND status = ?',
            Property::VERIFICATION_STATUS_OK, false, false, true ])
    end

    def featured_listing
      where([ 'verification_status = ? AND mark_as_blocked = ? AND mark_as_featured = ? AND status = ?',
              Property::VERIFICATION_STATUS_OK, false, true, true ])
    end
  end
end