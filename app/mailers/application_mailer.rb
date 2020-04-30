class ApplicationMailer < ActionMailer::Base
  #FIXME_AB:  use ENV[]

  default from: Figaro.env.from_email!
  layout 'mailer'
end
