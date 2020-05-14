class NotificationsController < ApplicationController
  before_action :ensure_logged_in
  after_action :lal

  def index
    #FIXME_AB: we can remove this if else thing. always use current_user.notifications
    user = User.find_by_id(params[:user_id])
    if current_user == user
      @notifications = current_user.notifications.not_viewed
      respond_to do |format|
       format.json {render json: { notifications: @notifications, timestamp: Time.current }, status: :ok, include: {question: {only: [:title, :url_slug], include: {user: {only: :name}}}}}
      end
    else
      render json: {error: "Cannot view another user notifications"}
    end
  end

  def lal
    Rails.logger.info { response.body }
    #FIXME_AB: remove this method and the after_action
  end
end
