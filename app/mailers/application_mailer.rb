class ApplicationMailer < ActionMailer::Base

  default from: ENV['from_email']
  layout 'mailer'
end
