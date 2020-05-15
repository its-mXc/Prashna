class NotificationsController < ApplicationController
  before_action :ensure_logged_in

  def index
    #FIXME_AB: we can remove this if else thing. always use current_user.notifications
    @notifications = current_user.notifications.not_viewed
    respond_to do |format|
      format.json {render json: { notifications: @notifications, timestamp: Time.current }, status: :ok, include: {question: {only: [:title, :url_slug],include: { user: {only: :name}}}}}
    end
  end

end
