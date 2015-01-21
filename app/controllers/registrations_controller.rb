class RegistrationsController < ApplicationController
  layout "sign_in"

  skip_before_action :authenticate_user!, except: [:destroy]

  def new
    if user_signed_in?
      redirect_to after_signed_in_path_for(current_user), notice: "You already signed in"
    end
    set_koala_auth
  end

  def create

  end

  def create_with_fb
    user = User.create_from_fb_token!(params[:fb_access_token])
    redirect_to sign_in_and_redirect_for(user), notice: 'You have been registered successfully'
  end

  def create_with_fb_m
    if params[:code]
      fb_token = Koala::Facebook::OAuth.new(ENV['FB_ID'], ENV['FB_SECRET'], sign_up_fb_m_url()).get_access_token(params[:code])
      user = User.create_from_fb_token!(fb_token)
      redirect_to after_signed_in_path_for(user), notice: 'You have been registered successfully'
    else
      redirect_to sign_up_path, notice: "Login with facebook was rejected"
    end
  end

  private
  def set_koala_auth
    @koala_auth = Koala::Facebook::OAuth.new(ENV['FB_ID'], ENV['FB_SECRET'])
  end
end