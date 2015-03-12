class Admin::CompaniesController < AdminController
  def index
    @companies = Company.order('name').page(params[:page])
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(filter_params)
    if(@company.save)
      redirect_to admin_companies_path, notice: 'Company has been created'
    else
      flash.now[:alert] = "Failed to save company"
      render :new
    end
  end

  def edit
    @company = Company.by_slug(params[:id])
  end

  def update
    @company = Company.by_slug(params[:id])
    if @company.update_attributes(filter_params)
      redirect_to admin_companies_path, notice: 'Company has been updated'
    else
      flash.now[:alert] = "Failed to save the company"
      render :edit
    end
  end

  def destroy
    @company = Company.by_slug(params[:id])
    if @company.destroy
      redirect_to admin_companies_path, notice: 'Company has been removed'
    else
      redirect_to admin_companies_path, alert: 'Failed to remove company'
    end
  end

  def filter_params
    params.require(:company).permit(:name, :license, :year_founded, :mobile_phone, :office_phone, :email,
                                    :website, :facebook, :twitter, :linkedin, :logo, :address, :summary,
                                    :lat, :lng, :bootsy_image_gallery_id)
  end

end