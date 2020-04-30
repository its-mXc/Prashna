class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def send_confirmation_mail(user_id)
    @user = User.find_by(id: user_id)
    #FIXME_AB: @user.verified? if @user && !@user.verified?
    unless @user.verified_at
      #FIXME_AB: read mail inceptor and prepend environment name to the subject. eg. [development] Confirm your account
      #FIXME_AB: do this for all environments except production
      #FIXME_AB: https://guides.rubyonrails.org/action_mailer_basics.html#intercepting-and-observing-emails
      mail to: @user.email, subject: 'Confirm your account'
    end
  end

  def send_password_reset_mail(user_id)
    @user = User.find_by(id: user_id)
    #FIXME_AB: same as above
    mail to: @user.email, subject: 'Password reset request'
  end
end
