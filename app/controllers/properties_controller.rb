class PropertiesController < HomeController
  def index
    @properties = Property.includes(:photos, :province, :district, :commune, :category, :user, :users)
                          .order('created_at DESC')
                          .listing
                          .page(params[:page])
  end

  def show
    @property = Property.find_by_url(params[:id])
  end

  def search
    @properties = Property.includes(:photos, :province, :district, :commune, :category, :user, :users)
                          .order('created_at')
                          .search(params)
                          .page(params[:page])
  end
end