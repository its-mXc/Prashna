class TopicController < ApplicationController

  before_action :ensure_logged_in


  def index
    @topics = Topic.search(params[:term]).distinct
    render json: @topics.map(&:name)
  end
end
