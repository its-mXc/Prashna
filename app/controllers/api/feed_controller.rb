module Api
  class FeedController < ApiBaseController

    def index
      #FIXME_AB: what if params[:token] is blank? it fill find the user with token null
      user = current_user_from_token(params[:auth_token])
      if user
        #FIXME_AB: eager loading. check bullet log
        @questions = user.questions.published
      else
        #FIXME_AB: set status always with error
        render json: { error: "No such user exist" }
      end
    end

  end
end
