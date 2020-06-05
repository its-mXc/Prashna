module Api
  class FeedController < ApiBaseController
    before_action :authorize

    def index
        @questions = current_user_from_token(params[:auth_token]).questions.published.includes([:comments, :answers, :topics])
    end

  end
end
