class NotificationsController < ApplicationController
  before_action :ensure_logged_in

  def index
    @notifications = current_user.notifications.not_viewed.distinct
    render json: { notifications: @notifications, timestamp: Time.current }, status: :ok
  end

end
