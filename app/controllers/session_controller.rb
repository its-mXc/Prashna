class SessionController < ApplicationController
  before_action :ensure_not_logged_in, only: [:new, :create]
  before_action :ensure_logged_in, only: [:destroy]

  def new
  end

  def create
    #FIXME_AB: only verfied user can login
    user = User.find_by(email: params[:email])
    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      if params[:remember]
        #FIXME_AB: take remember_me_expiry_days from figaro
        cookies.signed[:user_id] = { value: user.id, expires: Time.current + 15.days }
      end
      redirect_to my_profile_path
    else
      redirect_to login_url, alert: 'Invalid credentials'
    end
  end

  def destroy
    reset_session
    cookies.delete :user_id
    redirect_to login_url, notice: 'Logged out'
  end
end
