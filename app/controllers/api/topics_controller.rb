module Api
  class TopicsController < ApiBaseController
    def show
      topic = Topic.find_by_name(params[:id])
      if topic
        @questions = topic.questions.published
      else
        render json: {error: "No such topic exist"}
      end
    end
  end
end