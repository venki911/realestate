class ApplicationMailer < ActionMailer::Base
  default from: ENV['EMAIL_SUPPORT']
  layout 'mailer'
end
