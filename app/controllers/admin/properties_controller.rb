class Admin::PropertiesController < AdminController
  def index
    @properties = Property.order('created_at DESC').search(params)
    @properties = @properties.page(params[:page])
  end

  def review
    @property = Property.find(params[:id])
  end

  def update_review
    @property = Property.find(params[:id])
    rejected = @property.rejected?
    if @property.update_attributes(filter_review_params)
      UserMailer.property_rejected(@property).deliver_later if @property.rejected? && !rejected
      redirect_to admin_properties_path, notice: 'Property have been updated the property'
    else
      flash.now[:alert] = "Failed to update the property"
      render :review
    end
  end

  def toggle_featured
    @property = Property.find(params[:id])
    if @property.toggle_featured
      redirect_to admin_properties_path(view_context.app_params), notice: 'Property has been toggled mark as featured'
    else
      redirect_to admin_properties_path(view_context.app_params), alert: 'Failed to toggle mark as featured'
    end
  end

  def toggle_urgent
    @property = Property.find(params[:id])
    if @property.toggle_urgent
      redirect_to admin_properties_path(view_context.app_params), notice: 'Property has been toggled mark as urgent'
    else
      redirect_to admin_properties_path(view_context.app_params), alert: 'Failed to toggle mark as urgent'
    end
  end

  def toggle_exclusive
    @property = Property.find(params[:id])
    if @property.toggle_exclusive
      redirect_to admin_properties_path(view_context.app_params), notice: 'Property has been toggled mark as exclusive'
    else
      redirect_to admin_properties_path(view_context.app_params), alert: 'Failed to toggle mark as exclusive'
    end
  end

  def toggle_blocked
    @property = Property.find(params[:id])
    if @property.toggle_blocked
      redirect_to admin_properties_path(view_context.app_params), notice: 'Property has been toggled mark as block'
    else
      redirect_to admin_properties_path(view_context.app_params), alert: 'Failed to toggle mark as block'
    end
  end

  private

  def filter_review_params
    params.require(:property).permit(:status, :verification_status, :reject_reason, :mark_as_blocked, :mark_as_urgent, :mark_as_exclusive)
  end

end