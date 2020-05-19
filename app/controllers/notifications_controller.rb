class NotificationsController < ApplicationController
  before_action :ensure_logged_in

  def index
    # @notifications = current_user.notifications.not_viewed.distinct
    @notifications = current_user.notifications
    respond_to do |format|
      format.json {render json: { notifications: @notifications, timestamp: Time.current }, status: :ok, include: {question: {only: [:title, :url_slug],include: { user: {only: :name}}}}}
    end
  end

end
