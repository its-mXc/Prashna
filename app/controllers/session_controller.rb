class SessionController < ApplicationController

  #FIXME_AB: before action for new and create so that only non logged in use can see
  #FIXME_AB: before action for destory so that only logged in user can call it

  def new
    #FIXME_AB: make a method in application controller current_user
    #FIXME_AB: redirect to my profile
    redirect_to User.find(session[:user_id]) if session[:user_id]
  end

  def create
    #FIXME_AB: login with email and password
    user = User.find_by(name: params[:name])
    if user.try(:authenticate, params[:password])
      #FIXME_AB: we need to set session user id in all cases
      #FIXME_AB: if remember present set a signed cookie with 14 days expiry to save user's id
      session[:user_id] = user.id if params[:remember]
      #FIXME_AB: redirect to myprofile
      redirect_to user_path(user.id)
    else
      redirect_to login_url, alert: 'Invalid credentials'
    end
  end

  def destroy
    #FIXME_AB: use reset_session method to clear session
    #FIXME_AB: on logout clear the remember me cookie
    session[:user_id] = nil
    redirect_to login_url, notice: 'Logged out'
  end
end
