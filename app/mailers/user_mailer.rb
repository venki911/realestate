class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.forgot_password.subject
  #
  def forgot_password(user)
    @user = user
    mail to: @user.email
  end

  def password_changed(user)
    @user = user
    mail to: @user.email
  end

  def notify_blocked_status(user)
    @user = user
    mail to: @user.email
  end

  def property_rejected(property)
    @property = property
    mail to: @property.user.email
  end
end
