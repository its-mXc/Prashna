class NotificationsController < ApplicationController
  before_action :ensure_logged_in
  
  def index
    user = User.find_by_id(params[:user_id])
    if current_user == user
      @notifications = current_user.notifications.not_viewed
      render json: @notifications
    else
      render json: {error: "Cannot view another user notifications"}
    end
  end
end
