class Member::PropertiesController < MemberController

  before_action :check_over_quota, only: [:new, :create]

  def index
    @properties = current_user.properties.includes(:photos, :province, :district, :commune, :category, :user).order('created_at DESC').page(params[:page])
  end

  def new
    @property = current_user.properties.build(show_on_map: false)
    @property.show_on_map = true if current_user.individual?
  end

  def create
    @property = current_user.properties.build(filter_params)
    if @property.save
      redirect_to show_config_member_property_path(@property, next: true), notice: 'You property has been created'
    else
      flash.now[:alert] = "Failed to create property"
      render :new
    end
  end

  def show_map
    @property = Property.find_by_url(params[:id])
  end

  def update_map
    @property = Property.find_by_url(params[:id])
    if @property.update_attributes(filter_map_params)
      if params[:next].present?
        redirect_to show_photos_member_property_path(@property, next: true), notice: 'Property map has been saved'
      else
        redirect_to show_map_member_property_path(@property), notice: 'Property map has been saved'
      end
    else
      flash.now[:alert] = @property.errors.full_messages.first
      render :show_map
    end
  end

  def show_config
    @property = Property.find_by_url(params[:id])
  end

  def update_config
    @property = Property.find_by_url(params[:id])
    if @property.update_attributes(filter_config_params)
      if params[:next].present?
        redirect_to show_map_member_property_path(@property, next: true), notice: 'Property features have been saved'
      else
        redirect_to show_config_member_property_path(@property), notice: 'Property feature have been saved'
      end
    else
      flash.now[:alert] = @property.errors.full_messages.first
      render :show_config
    end
  end

  def show_photos
    @property = Property.find_by_url(params[:id])
  end

  def show_note
    @property = Property.find_by_url(params[:id])
  end

  def update_note
    @property = Property.find_by_url(params[:id])
    if @property.update_attributes(filter_note_params)
      redirect_to show_note_member_property_path(@property), notice: 'Successfully update property note'
    else
      flash.now.alert = 'Failed to update property note'
      render :show_note
    end
  end

  def edit
    @property = current_user.properties.find_by_url(params[:id])
  end

  def update
    @property = current_user.properties.find_by_url(params[:id])
    @property.resume_rejected!
    
    if(@property.update_attributes(filter_params))
      redirect_to edit_member_property_path(@property), notice: 'Property has been updated'
    else
      flash.now[:alert] = "Failed to update property"
      render :edit
    end
  end

  private

  def filter_note_params
    params.require(:property).permit(:note, :bootsy_image_gallery_id)
  end

  def filter_config_params
    configs  = Property.stored_attributes[:config_features]
    configs += Property.stored_attributes[:config_equipments]
    configs += Property.stored_attributes[:config_services]
    params.require(:property).permit(*configs)
  end

  def filter_map_params
    params.require(:property).permit( :lat, :lng, :show_on_map)
  end

  def filter_params
    params.require(:property).permit(:code_ref, :borey_name, :category_id, :type_of,
           :price_per_unit_rent, :price_per_size_rent, :price_per_duration_rent,
           :price_per_unit_sale, :price_per_size_sale,
           :building_width, :building_length, :building_area, :building_unit,
           :width, :length, :area, :unit,
           :status, :mark_as_urgent,
           :province_id, :district_id, :commune_id)
  end

  def check_over_quota
    if current_user.over_quota?
      redirect_to member_properties_path, notice: 'You have reached max number of quota'
    end
  end
end