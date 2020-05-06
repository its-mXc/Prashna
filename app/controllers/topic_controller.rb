class TopicController < ApplicationController

  before_action :ensure_logged_in

  #FIXME_AB: you should check that user is logged in

  def index
    #FIXME_AB: find unique so that you don't need to do it while making json
    @topics = Topic.search(params[:term]).distinct
    render json: @topics.map(&:name)
  end
end
