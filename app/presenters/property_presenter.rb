class PropertyPresenter < SimpleDelegator
  # include Rails.application.routes.url_helpers
  include ActionView::Helpers

  def initializer(property)
    super(property)
    # @view_context = view_context
  end

  def display_verification_status
    if verification_status == Property::VERIFICATION_STUTUS_PENDING
      content_tag(:span, verification_status, class: 'verification label label-default')
    elsif verification_status == Property::VERIFICATION_STATUS_OK
      content_tag(:span, verification_status, class: 'verification label label-success')
    else
      content_tag(:span, verification_status, class: 'verification label label-danger')
    end
  end

  def display_title
    result = [] 
    result << commune.name if commune
    result << district.name if district
    result << province.name if province
    code_ref + " - " + result.join(", ")

  end

  def display_user
    "By #{user.first_name}"
  end

  def display_description
    result = "#{category.name} for #{type_of} #{price_per_unit}$ "
    if price_per_size != Property::PRICE_PER_SIZE_TOTAL
      result += "per #{price_per_size}"
    end
    result
  end

  def price_value
    result = price_per_unit

    case price_per_size
    when Property::PRICE_PER_SIZE_HECTAR
      price_per_unit * area_value/10000
    when Property::PRICE_PER_SIZE_M2
      price_per_unit * area_value
    else
      price_per_unit
    end
  end

  def display_area
    result = []
    if area
      result << "#{area} #{unit}"
    end

    if(width && length)
      result << " #{width} m x #{length} m"
    end
    result.join(", ")
  end

  def area_value
    if area
      (unit == Property::UNIT_HECTAR) ? area * 10000 : area
    else
      width * height
    end
  end

  def main_thumb_photo
    photos_count > 0 ? photos.first.image_name.thumb.url : default_thumb_photo
  end


  def default_thumb_photo
    'properties/default.png'
  end



end