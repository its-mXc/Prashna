class PasswordController < ApplicationController
  def forgot
  end

  def find_user
    @user = User.find_by(email: email_params[:email])
    if @user
      @user.generate_password_token
      UserMailer.send_password_reset_mail(@user.id).deliver_now
      redirect_to login_path, notice: "Check your inbox for password reset mail"
    else
      redirect_to forgot_password_path, notice: "No such email id exists"
    end
  end

  def reset
    @user = User.find_by(password_reset_token: params[:reset_token])
    if @user && Time.current >= @user.password_token_created_at
      @user.expire_password_token
      redirect_to forgot_password_path, notice: "Link expired"
    elsif @user.nil?
      redirect_to forgot_password_path, notice: "Invalid Link"
    end
  end

  def update
    @user = User.find_by(password_reset_token: password_params[:password_reset_token])
    p @user
    respond_to do |format|
      if @user.update(password_params)
        @user.expire_password_token
        format.html { redirect_to login_url, notice: 'Password updated sucessfuly' }
      else
        format.html { render :reset }
      end
    end
  end

  private def email_params
    params.require(:user).permit(:email)
  end

  private def password_params
    #FIXME_AB: password_reset_token is not required here
    params.require(:user).permit(:password, :password_confirmation, :password_reset_token)
  end
end
