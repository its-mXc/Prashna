class PasswordController < ApplicationController
  def forgot
  end

  def find_user
    @user = User.find_by(email: email_params[:email])
    if @user
      @user.generate_password_token
      UserMailer.send_password_reset_mail(@user.id).deliver_now
      redirect_to login_path, notice: t('password_reset_mail_sent')
    else
      redirect_to forgot_password_path, notice: t('no_email_id')
    end
  end

  def reset
    @user = User.find_by(password_reset_token: params[:reset_token])
    if @user && Time.current >= @user.password_token_expire_at
      @user.expire_password_token
      redirect_to forgot_password_path, notice: t('link_expired')
    elsif @user.nil?
      redirect_to forgot_password_path, notice: t('invalid_link')
    end
  end

  def update
    @user = User.find_by(password_reset_token: params[:user][:password_reset_token])
    @user.assign_attributes(password_params)
    respond_to do |format|
      if @user.save(context: :password_entered)
        @user.expire_password_token
        format.html { redirect_to login_url, notice: t('password_update_successfull') }
      else
        format.html { render :reset }
      end
    end
  end

  private def email_params
    params.require(:user).permit(:email)
  end

  private def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
