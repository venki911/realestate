class Admin::UsersController < AdminController
  def index
    @users = User.includes(:company).order('created_at DESC').search(params).page(params[:page])
  end

  def toggle_block
    user = User.find(params[:id])
    if user.toggle_blocked_status
      redirect_to admin_users_path, notice: "User: #{user.full_name} has been #{user.blocked_status}"
    else
      user.blocked = !user.blocked
      redirect_to admin_users_path, alert: "Faild to block this user, Please try again"
    end
  end

end