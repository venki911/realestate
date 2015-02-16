class PropertiesController < HomeController
  def index
    @properties = Property.listing.page(params[:page])
  end

end