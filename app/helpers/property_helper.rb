module PropertyHelper
  def active_index active
    active ? ' active ' : ''
  end

  def tag_facilities facilities, limit = 1000
    results = []
    i = 1
    facilities.each do |key, value|
      text = key.to_s.titleize
      if value == Property::FACILITY_BOOL
        text = "#{value} #{text}"
      else
        text = pluralize(value.to_i, text)
      end

      results  << "<span class='facility-tag'>#{text}</span>"
      if( i >= limit)
        results  << "More..."
        break
      end
      i += 1
    end
    results.join(", ").html_safe
  end

  def marked_items_for property
    property.marked_items.map{|item| "<span class='big'>#{item}</span>" }.join(", ").html_safe
  end

  def land_dimension(property)
    results = []
    if property.width.present? && property.length.present?
      results << "#{property.width}m x #{property.length}m"
    end

    if property.area
      results << "#{property.area} #{property.unit}"
    end
    results.join(" ~ ")
  end

  def building_dimension(property)
    results = []
    if property.width.present? && property.length.present?
      results << "#{property.building_width}m x #{property.building_length}m"
    end

    if property.area
      results << "#{property.building_area} #{property.building_unit}"
    end
    results.join(" ~ ")
  end
end