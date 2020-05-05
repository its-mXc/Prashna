class TopicController < ApplicationController

  def index
    @topics = Topic.search(params[:term])
    render json: @topics.map(&:name).uniq 
  end
end
