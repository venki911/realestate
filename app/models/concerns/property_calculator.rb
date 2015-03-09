module PropertyCalculator
  FACILITY_BOOL = "&#10003"

  attr_accessor :features_list
  def has_map?
    self.lat.present? && self.lng.present? && self.show_on_map?
  end

  def special?
    self.mark_as_urgent || self.mark_as_exclusive
  end

  def building_size?
    building_width.present? && building_length.present? && building_area.present?
  end

  def logo
    photos_count > 0 ? photos.first.image_name.thumb.url : default_thumb_url
  end

  def default_thumb_url
    'logo/realestate.png'
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

  def area_in_m2
    self.unit == Property::UNIT_M2 ? self.area : (self.area * 10000)
  end

  def building_area_in_m2
    self.building_unit == Property::UNIT_M2 ? self.building_area : (self.building_area * 10000)
  end

  def operation_area_in_m2
    self.category.is_land ? area_in_m2 : building_area_in_m2
  end

  def operation_area_in_hectar
    self.category.is_land ? area_in_hectar : building_area_in_hectar
  end

  def area_in_hectar
    self.unit == Property::UNIT_M2 ? (self.area/10000) : self.area
  end

  def building_area_in_hectar
    self.building_unit == Property::UNIT_M2 ? (self.building_area/10000) : self.building_area
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

  def calculate_and_set_total_price_rent
    if self.type_of == Property::TYPE_RENT || self.type_of == Property::TYPE_SALE_RENT
      if self.price_per_size_rent == Property::PRICE_PER_SIZE_TOTAL
        self.total_price_rent = self.price_per_unit_rent
      elsif self.price_per_size_rent == Property::PRICE_PER_SIZE_M2
        self.total_price_rent = self.price_per_unit_rent * operation_area_in_m2
      elsif self.price_per_size_rent == Property::PRICE_PER_SIZE_HECTAR
        self.total_price_rent = self.price_per_unit_rent * operation_area_in_hectar
      end

      #total price rent per month
      if self.price_per_duration_rent == Property::PRICE_PER_DURATION_YEAR
        self.total_price_rent = (self.total_price_rent/12).to_i
      end
    end
  end

  def calculate_and_set_total_price_sale
    if self.type_of != Property::TYPE_RENT
      if self.price_per_size_sale == Property::PRICE_PER_SIZE_TOTAL
        self.total_price_sale = self.price_per_unit_sale
      elsif self.price_per_size_sale == Property::PRICE_PER_SIZE_M2
        self.total_price_sale = self.price_per_unit_sale * operation_area_in_m2
      elsif self.price_per_size_sale == Property::PRICE_PER_SIZE_HECTAR
        self.total_price_sale = self.price_per_unit_sale * operation_area_in_hectar
      end
    end
  end


end