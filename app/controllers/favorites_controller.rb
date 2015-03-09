class FavoritesController < ApplicationController
  layout 'home'

  def create
    favorite = Favorite.new(property_id: params[:property_id], user_id: current_user.id)

    begin
      favorite.save!
      render json: favorite
    rescue
      render json: favorite.errors.full_messages, status: 400
    end
  end


end