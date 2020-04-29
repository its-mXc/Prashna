class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def send_confirmation_mail(user)
    @user = user
    #FIXME_AB: send mail only if user is not verified
    mail to: @user.email, subject: 'Confirm your account'
  end

  def send_password_reset_mail(user)
    @user = user

    mail to: @user.email, subject: 'Password reset request'
  end
end
