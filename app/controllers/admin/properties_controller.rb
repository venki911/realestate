class Admin::PropertiesController < AdminController
  def index
    @properties = Property.order('created_at').page(params[:page])
  end

  private
  def filter_params
    params.require(:category).permit(:name)
  end

end