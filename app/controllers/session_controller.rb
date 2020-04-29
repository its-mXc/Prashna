class SessionController < ApplicationController
  def new
    redirect_to User.find(session[:user_id]) if session[:user_id]
  end
  def create
    user = User.find_by(name: params[:name])
    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id if params[:remember]
      redirect_to user_path(user.id)
    else
      redirect_to login_url, alert: 'Invalid credentials'
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to login_url, notice: 'Logged out'
  end
end
