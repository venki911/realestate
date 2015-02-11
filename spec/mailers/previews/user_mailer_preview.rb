class UserMailerPreview < ActionMailer::Preview

  def forgot_password
    define_user_class
    user = Struct::User.new("channa.info@gmail.com", "Channa", "Ly", "rqthghujc14567-378")
    UserMailer.forgot_password(user)
  end

  def password_changed
    define_user_class
    user = Struct::User.new("channa.info@gmail.com", "Channa", "Ly", "rqthghujc14567-378")
    UserMailer.password_changed(user)
  end

  def notify_blocked_status
    define_user_class
    user = Struct::User.new("channa.info@gmail.com", "Channa", "Ly", "rqthghujc14567-378", "blocked")
    UserMailer.notify_blocked_status(user)
  end

  def define_user_class
    Struct.new("User", :email, :first_name, :last_name, :reset_password_token, :blocked_status)
  end
end