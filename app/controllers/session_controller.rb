class SessionController < ApplicationController
  before_action :ensure_not_logged_in, only: [:new, :create]
  before_action :ensure_logged_in, only: [:destroy]

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user.try(:authenticate, params[:password])
      if user.verified?
        if user.disabled
          redirect_to login_path, notice: "Your account is disabled"
        else
          session[:user_id] = user.id
          if params[:remember]
            cookies.signed[:user_id] = { value: user.id, expires: Time.current + ENV['remember_me_expiry_days'].to_i.days }
          end
          if user.admin?
            redirect_to admin_path
          elsif user.user?
            redirect_to my_profile_path
          end
        end
      else
        redirect_to login_path, notice: 'Please verify your email first'
      end
    else
      redirect_to login_path, notice: 'Invalid credentials'
    end
  end

  def destroy
    reset_session
    cookies.delete :user_id
    redirect_to login_url, notice: 'Logged out'
  end
end
