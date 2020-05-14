class NotificationsController < ApplicationController
  before_action :ensure_logged_in
  after_action :lal
  
  def index
    user = User.find_by_id(params[:user_id])
    if current_user == user
      @notifications = current_user.notifications.not_viewed
      respond_to do |format|
       format.json {render json: { notifications: @notifications, timestamp: Time.current }, status: :ok, include: {question: {only: [:title, :url_slug],include: {user: {only: :name}}}}}
      end
    else
      render json: {error: "Cannot view another user notifications"}
    end
  end

  def lal
    Rails.logger.info { response.body }
  end
end
