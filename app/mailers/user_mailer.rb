class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def send_confirmation_mail(user_id)
    @user = User.find_by(id: user_id)
    unless @user.verified_at
      mail to: @user.email, subject: 'Confirm your acscount'
    end
  end
  
  def send_password_reset_mail(user_id)
    @user = User.find_by(id: user_id)

    mail to: @user.email, subject: 'Password reset request'
  end
end
