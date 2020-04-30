class PasswordController < ApplicationController
  def forgot
  end

  def find_user
    @user = User.find_by(email: password_params[:email])
    UserMailer.send_password_reset_mail(@user.id).deliver_now
    redirect_to login_path, notice: "Check your inbox for passwors reset mail"
  end

  def reset
    @user = User.find_by(confirmation_token: params[:token])
  end

  def update
    @user = User.find_by(id: params[:user][:user_id])
    respond_to do |format|
      if @user.update(password_params)
        format.html { redirect_to login_url, notice: 'User was successfully updated.' }
      else
        format.html { render :reset }
      end
    end
  end

  private def password_params
    params.require(:user).permit(:password, :password_confirmation, :email)
  end
end
