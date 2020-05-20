class TopicController < ApplicationController
  before_action :ensure_logged_in

  def index
    @topics = Topic.search(params[:term]).distinct
    render json: @topics.pluck(:name)
  end
end
