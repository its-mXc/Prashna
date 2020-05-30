module Api
  class FeedController < ApiBaseController
    def index
      user = User.find_by_auth_token(params[:auth_token])
      if user
        @questions = user.questions.published
      else
        render json: {error: "No such user exist"}
      end
    end
  end
end