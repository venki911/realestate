class Admin::CategoriesController < AdminController
  def index
    @categories = Category.order('name').page(params[:page])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(filter_params)
    if @category.save
      redirect_to admin_categories_path, notice: 'Category has been saved successfully'
    else
      flash.now[:alert] = "Failed to save category"
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(filter_params)
      redirect_to admin_categories_path, notice: 'Category has been updated'
    else
      flash.now[:alert] = "Failed to update category"
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to admin_categories_path, notice: "Category has been removed"
  end

  private
  def filter_params
    params.require(:category).permit(:name)
  end

end