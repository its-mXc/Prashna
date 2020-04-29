class ApplicationMailer < ActionMailer::Base
  #FIXME_AB: lets use figaro gem https://github.com/laserlemon/figaro for env. based config values
  #FIXME_AB: make use of figaro required keys
  default from: 'from@example.com'
  layout 'mailer'
end
