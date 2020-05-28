class ApplicationController < ActionController::Base

  helper_method :current_user, :logged_in?
  before_action :prepare_exception_notifier

  def current_user
      if cookies.signed[:user_id]
        @current_user ||= User.find_by(id: cookies.signed[:user_id])
      elsif session[:user_id]
        @current_user ||= User.find_by(id: session[:user_id])
      else
        @current_user = nil
      end
  end

  def logged_in?
    !!current_user
  end

  private def ensure_not_logged_in
    if logged_in?
      redirect_to my_profile_path, notice: t('logged_in')
    end
  end

  private def ensure_logged_in
    unless logged_in?
      redirect_to login_url, notice: t('not_logged_in')
    end
  end

  private def prepare_exception_notifier
    request.env["exception_notifier.exception_data"] = {
      current_user: current_user
    }
  end
end
