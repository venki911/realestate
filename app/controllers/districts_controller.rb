class DistrictsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @districts = District.order("name DESC")
    @districts= @districts.where(province_id: params[:province_id]) if params[:province_id].present?
    render json: @districts
  end
end