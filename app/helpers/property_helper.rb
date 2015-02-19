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
end