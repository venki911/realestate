class PropertiesController < HomeController
  def index
    @properties = Property.listing.page(params[:page])
  end

  def show
    @property = Property.find_by_url(params[:id])
  end

end