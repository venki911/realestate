class Member::UsersController < MemberController
  def profile
  end

  def update_profile
    if current_user.update_attributes(filter_profile_params)
      redirect_to member_profile_path, notice: 'You profile has been updated'
    else
      flash.now[:alert] = 'Failed to update your profile'
      render :profile
    end
  end

  def company
  end

  def update_company
    if current_user.update_attributes(filter_company_params)
      redirect_to member_company_path, notice: 'You have been updated your company'
    else
      flash.now[:alert] = 'Failed to update your company'
      render :company
    end
  end

  def photo

  end

  def update_photo
    if params[:user]
      if current_user.update_attributes(filter_photo_params)
        flash.now[:notice] = 'Your photo has been updated'
        render :crop
      else
        flash.now[:alert] = 'Failed to update your photo'
        render :photo
      end
    else
      flash.now[:info] = 'No photo is updated'
      render :photo
    end
  end

  def crop

  end

  def update_crop
    if current_user.update_attributes(filter_crop_params)
      redirect_to member_crop_path, notice: 'Your avatar has been updated'
    else
      flash.now[:alert] = 'Failed to update avatar, please try again'
      render :crop
    end
  end

  def new_password

  end

  def create_password
    current_user.with_site_sign_up_step
    if current_user.update_password_and_send_alert(filter_password_params)
      redirect_to member_change_password_path, notice: 'Your password has been created'
    else
      current_user.with_fb_sign_up_step
      flash.now[:alert] = 'Could not create your password'
      render :new_password
    end
  end

  def change_password

  end

  def update_password
    old_password = params[:user][:old_password]
    if current_user.check_password(old_password) && current_user.update_password_and_send_alert(filter_password_params)
      redirect_to member_change_password_path, notice: 'Your password has been updated'
    else
      flash.now[:alert] = 'Failed to update your password'
      render :change_password
    end
  end

  private
  def filter_profile_params
    params.require(:user).permit(:first_name, :last_name, :phone, :email, :user_name, :gender, :role, :bio, :bootsy_image_gallery_id)
  end

  def filter_company_params
    params.require(:user).permit(:company_id)
  end

  def filter_password_params
    params.require(:user).permit(:password, :password_confirmation, :old_password)
  end

  def filter_photo_params
    params.require(:user).permit(:avatar)
  end

  def filter_crop_params
    params.require(:user).permit(:crop_x, :crop_y, :crop_w, :crop_h)
  end

end