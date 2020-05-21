class TopicController < ApplicationController
  before_action :set_topic, only: :questions

  def index
    @topics = Topic.search(params[:term]).distinct
    render json: @topics.pluck(:name)
  end

  def questions
    @topic = Topic.find_by(id: params[:id])
    @questions = @topic.questions.published
  end
  
  private def set_topic
    @topic = Topic.find_by(id: params[:id])
    unless @topic
      redirect_to root_path, notice: t('.topic_not_found')
    end
  end
end
