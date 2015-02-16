class PropertyPresenter < SimpleDelegator
  # include Rails.application.routes.url_helpers
  include ActionView::Helpers

  def initializer(property, view_context)
    super(property)
    @view_context = view_context
  end

  def display_verification_status
    if verification_status == Property::VERIFICATION_STUTUS_PENDING
      content_tag(:span, verification_status, class: 'float-bottom label label-warning')
    elsif verification_status == Property::VERIFICATION_STATUS_OK
      content_tag(:span, verification_status, class: 'float-bottom label label-success')
    else
      content_tag(:span, verification_status, class: 'float-bottom label label-danger')
    end
  end

  def display_location
    result = [] 
    result << commune.name if commune
    result << district.name if district
    result << province.name if province
    result.join(", ")
  end

  def display_type
    result = borey_name.present? ? "#{borey_name} - #{category.name} " : category.name
    "#{result} for #{type_of} - #{display_id}"
  end
end