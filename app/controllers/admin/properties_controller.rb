class Admin::PropertiesController < AdminController
  def index
    @properties = Property.order('created_at DESC').page(params[:page])
  end

  def review
    @property = Property.find(params[:id])
  end

  def update_review
    @property = Property.find(params[:id])
    if @property.update_attributes(filter_review_params)
      redirect_to admin_properties_path, notice: 'Property have been updated the property'
    else
      flash.now[:alert] = "Failed to update the property"
      render :review
    end
  end

  private

  def filter_review_params
    params.require(:property).permit(:status, :verification_status, :reject_reason, :mark_as_urgent, :mark_as_exclusive)
  end

end