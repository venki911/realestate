class Admin::CommunesController < AdminController
  def index
    @communes = Commune.includes(:district, :province).order('created_at DESC').page(params[:page])
  end

  def new
    @commune = Commune.new
  end

  def create
    @commune = Commune.new(filter_params)
    if @commune.save
      redirect_to admin_communes_path, notice: 'Commune has been saved successfully'
    else
      flash.now[:alert] = "Failed to save commune"
      render :new
    end
  end

  def edit
    @commune = Commune.find(params[:id])
  end

  def update
    @commune = Commune.find(params[:id])
    if @commune.update_attributes(filter_params)
      redirect_to admin_communes_path, notice: 'Commune has been updated'
    else
      flash.now[:alert] = "Failed to update Commune"
      render :edit
    end
  end

  def destroy
    @commune = Commune.find(params[:id])
    @commune.destroy
    redirect_to admin_communes_path, notice: "Commune has been removed"
  end

  private
  def filter_params
    params.require(:commune).permit(:name, :district_id, :province_id)
  end

end