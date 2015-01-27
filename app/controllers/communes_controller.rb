class CommunesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @communes = Commune.order("name DESC")
    @communes= @communes.where(district_id: params[:district_id]) if params[:district_id].present?
    render json: @communes
  end
end