module Api
  class TopicsController < ApiBaseController
    before_action :check_activity_limit
    #FIXME_AB: make this after action
    after_action :set_activity

    def show
      topic = Topic.find_by_name(params[:id])
      if topic
        @questions = topic.questions.published.recent.limit(ENV["topic_api_question_amount"].to_i)
      else
        render json: {error: "No such topic exist"}
      end
    end

    #FIXME_AB: move this to api base
   
  end
end
