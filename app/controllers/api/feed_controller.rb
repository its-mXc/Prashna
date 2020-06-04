module Api
  class FeedController < ApiBaseController
    before_action :authorize

    def index
      #FIXME_AB: what if params[:token] is blank? it fill find the user with token null
        #FIXME_AB: eager loading. check bullet log
        @questions = current_user_from_token(params[:auth_token]).questions.published.includes([:comments, :answers, :topics])
    end

  end
end
