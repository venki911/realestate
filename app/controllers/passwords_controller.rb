class PasswordsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @password_form = PasswordForm.new
  end

  def create
    @password_form = PasswordForm.new(params[:password_form])
    if(@password_form.valid?)
      user = @password_form.user
      user.send_password_reset
      redirect_to root_url, notice: "Email sent with password reset instructions."
    else
      flash.now.alert = "Invalid Email address, Please try again"
      render :new
    end
  end

  def edit
    @user = User.find_by(reset_password_token: params[:id])
    if !@user
      redirect_to root_url, alert: "Invalid reset password token"
    elsif @user.reset_password_token_at < 1.day.ago
      @user.reset_password_token = nil
      @user.save!
      redirect_to root_url, alert: "Your password token has expired"
    end
  end

  def update
    @user = User.find_by(reset_password_token: params[:id])
    if @user.update_password_and_send_alert(filter_params_update_password)
      redirect_to root_url, notice: 'Your password has been changed'
    else
      render :edit
    end
  end

  private
  def filter_params_update_password
    params.require(:user).permit(:password, :password_confirmation)
  end
end