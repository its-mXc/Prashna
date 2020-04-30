class PasswordController < ApplicationController
  def forgot
  end

  def find_user
    @user = User.find_by(email: password_params[:email])
    #FIXME_AB: what if user not found
    #FIXME_AB: use deliver_later
    UserMailer.send_password_reset_mail(@user.id).deliver_now
    #FIXME_AB: password reset token should be valid for x hours. (figaro). save password_reset_token and password_token_created_at
    #FIXME_AB: tell user that the password reset link is valid for x hours
    redirect_to login_path, notice: "Check your inbox for password reset mail"
  end

  def reset
    @user = User.find_by(confirmation_token: params[:token])
    #FIXME_AB: what if user not found
    #FIXME_AB: check for token is valid or not, if expired clear db
  end

  def update
    #FIXME_AB: find by token
    @user = User.find_by(id: params[:user][:user_id])
    respond_to do |format|
      #FIXME_AB: @user.reset_password(password, confirmation_password) and clear password_reset_token and password_token_created_at
      if @user.update(password_params)
        #FIXME_AB: password updated successfully
        format.html { redirect_to login_url, notice: 'User was successfully updated.' }
      else
        format.html { render :reset }
      end
    end
  end

  #FIXME_AB: don't use shared
  private def password_params
    params.require(:user).permit(:password, :password_confirmation, :email)
  end
end
