class FavoritesController < ApplicationController
  layout 'home'

  def create
    favorite = current_user.favorites.build(property_id: params[:property_id])
    begin
      favorite.save!
      render json: favorite
    rescue
      render json: favorite.errors.full_messages, status: 400
    end
  end

  def index
    @properties = Property.where(id: current_user.favorites.pluck(:property_id)).page(params[:page])
  end

end