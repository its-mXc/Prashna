module Api
  class FeedController < ApiBaseController

    def index
      user = current_user_from_token(params[:auth_token])
      if user
        @questions = user.questions.published
      else
        render json: {error: "No such user exist"}
      end
    end
    
  end
end