class Admin::ProvincesController < AdminController
  def index
    @provinces = Province.order('created_at DESC').page(params[:page])
  end

  def new
    @province = Province.new
  end

  def create
    @province = Province.new(filter_params)
    if @province.save
      redirect_to admin_provinces_path, notice: 'Province has been saved successfully'
    else
      flash.now[:alert] = "Failed to save province"
      render :new
    end
  end

  def edit
    @province = Province.find(params[:id])
  end

  def update
    @province = Province.find(params[:id])
    if @province.update_attributes(filter_params)
      redirect_to admin_provinces_path, notice: 'Province has been updated'
    else
      flash.now[:alert] = "Failed to update province"
      render :edit
    end
  end

  def destroy
    @province = Province.find(params[:id])
    @province.destroy
    redirect_to admin_provinces_path, notice: "Province has been removed"
  end

  private
  def filter_params
    params.require(:province).permit(:name)
  end

end