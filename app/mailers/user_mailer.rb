class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def send_confirmation_mail(user_id)
    @user = User.find_by(id: user_id)
    if @user && !@user.verified?
      mail to: @user.email, subject: 'Confirm your account'
    end
  end

  def send_password_reset_mail(user_id)
    @user = User.find_by(id: user_id)
    #FIXME_AB: what if user not found.
    mail to: @user.email, subject: 'Password reset request'
  end
end
