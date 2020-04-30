class ApplicationMailer < ActionMailer::Base
  default from: Figaro.env.from_email!
  layout 'mailer'
end
