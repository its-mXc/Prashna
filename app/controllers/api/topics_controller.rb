module Api
  class TopicsController < ApiBaseController
    before_action :check_activity_limit
    before_action :set_activity

    def show
      topic = Topic.find_by_name(params[:id])
      if topic
        @questions = topic.questions.published.recent.limit(ENV["topic_api_question_amount"].to_i)
      else
        render json: {error: "No such topic exist"}
      end
    end

    private def check_activity_limit
      if FeedActivity.where("created_at >= ? and ip = ? and url = ?", 1.hour.ago, request.ip, request.url).count > ENV["topic_requests_per_hour"].to_i
        render json: {error: "Limit Reached" }
      end
    end

    private def set_activity
      FeedActivity.create(ip: request.ip, url: request.url)
    end
  end
end