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
    @user = User.find_by_id(user_id)

    if @user
      mail to: @user.email, subject: 'Password reset request'
    else
      logger.error "Cannot find user, id = #{user_id}"
    end
  end

  def send_question_answered_mail(answer_id)
    @answer = Answer.find_by_id(answer_id)

    @user = @answer.question.user

    if @user
      mail to: @user.email, subject: 'Question answered'
    else
      logger.error "Cannot find user, id = #{user_id}"
    end
  end
end
