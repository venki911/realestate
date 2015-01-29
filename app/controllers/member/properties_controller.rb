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
    @property = current_user.properties.find_by(id: params[:id])
    @property.resume_rejected!
    
    if(@property.update_attributes(filter_params))
      redirect_to member_properties_path, notice: 'Property has been updated'
    else
      flash.now[:alert] = "Failed to update property"
      render :edit
    end
  end

  private
  def filter_params
    params.require(:property).permit( :code_ref, :borey_name, :category_id, :note,
           :type_of, :price_per_unit, :price_per_size, :price_per_duration,
           :width, :length, :area, :unit,
           :province_id, :district_id, :commune_id, :lat, :lon
    )
  end

  def check_over_quota
    if current_user.over_quota?
      redirect_to member_properties_path, notice: 'You have reached max number of quota'
    end
  end
end