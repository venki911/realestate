class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.forgot_password.subject
  #

  def welcome_member(user)
    headers['X-MC-Tags'] = "welcome_member"
    headers['X-MC-Metadata'] =  { "reset_password_token": user.reset_password_token }
    @user = user
    mail to: @user.email
  end

  def forgot_password(user)
    headers['X-MC-Tags'] = "forgot_password"
    headers['X-MC-Metadata'] =  {"reset_password_token": user.reset_password_token }
    @user = user
    mail to: @user.email
  end

  def password_changed(user)
    headers['X-MC-Tags'] = "password_changed"
    @user = user
    mail to: @user.email
  end

  def notify_blocked_status(user)
    headers['X-MC-Tags'] = "notify_blocked_status"
    @user = user
    mail to: @user.email
  end

  def property_rejected(property)
    headers['X-MC-Tags'] = "property_rejected"
    @property = property
    mail to: @property.user.email
  end
end
