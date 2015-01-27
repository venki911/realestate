class Member::PropertiesController < MemberController

  def index
    @properties = current_user.properties.order('created_at DESC').page(params[:page])
  end

  def new
    @property = current_user.properties.build
  end

  def create
    @property = current_user.properties.build(filter_params)
    if @property.save
      redirect_to member_properties_path, notice: 'You property has been created'
    else
      flash.now[:alert] = "Failed to create property"
      render :new
    end
  end

  def edit
    @property = current_user.properties.find(params[:id])
  end

  def update
    @property = current_user.properties.find(params[:id])
    p "filter_params: #{filter_params}"
    if(@property.update_attributes(filter_params))
      redirect_to member_properties_path, notice: 'Property has been updated'
    else
      flash.now[:alert] = "Failed to update property"
      render :edit
    end
  end

  private
  def filter_params
    params.require(:property).permit( :code_ref, :borey_name, :category_id,
           :type_of, :price_per_unit, :price_per_size, :price_per_duration,
           :width, :height, :area, :unit,
           :province_id, :district_id, :commune_id, :lat, :lon
    )
  end
end