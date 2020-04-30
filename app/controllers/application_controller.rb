class ApplicationController < ActionController::Base

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(id: cookies.signed[:user_id])
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    #FIXME_AB: you can also do "!!current_user" or current_user.nil?
    current_user != nil
  end

  private def ensure_not_logged_in
    if logged_in?
      redirect_to my_profile_path, notice: "Already logged in"
    end
  end

  private def ensure_logged_in
    unless logged_in?
      redirect_to login_url, notice: "Please log in first"
    end
  end
end
