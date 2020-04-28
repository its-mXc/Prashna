class SessionController < ApplicationController
  def new

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
    # Counter.find_by(user_id:session[:user_id]).destroy_all
    session[:user_id] = nil
    # redirect_to store_index_url, notice: 'Logged out'
  end
end
