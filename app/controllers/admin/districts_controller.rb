class Admin::DistrictsController < AdminController
  def index
    @districts = District.includes(:province).order('created_at DESC').page(params[:page])
  end

  def new
    @district = District.new
  end

  def create
    @district = District.new(filter_params)
    if @district.save
      redirect_to admin_districts_path, notice: 'District has been saved successfully'
    else
      flash.now[:alert] = "Failed to save district"
      render :new
    end
  end

  def edit
    @district = District.find(params[:id])
  end

  def update
    @district = District.find(params[:id])
    if @district.update_attributes(filter_params)
      redirect_to admin_districts_path, notice: 'District has been updated'
    else
      flash.now[:alert] = "Failed to update District"
      render :edit
    end
  end

  def destroy
    @district = District.find(params[:id])
    @district.destroy
    redirect_to admin_districts_path, notice: "District has been removed"
  end

  private
  def filter_params
    params.require(:district).permit(:name, :province_id)
  end

end