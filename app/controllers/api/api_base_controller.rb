module Api
  class ApiBaseController < ActionController::Base
    before_action :set_default_response_format
    helper_method :current_user_from_token

    protected def set_default_response_format
      request.format = :json
    end

    #FIXME_AB: not using this token parameter
    def current_user_from_token(token)
      User.find_by_auth_token(params[:auth_token])
    end

    private def authorize
      if params[:auth_token].nil?
        render json: {error: "No token in request"}, status: 403
        return
      end
      unless current_user_from_token(params[:auth_token])
        render json: {error: "Unauthorized token"}, status: 403
        return
      end
    end

    private def check_activity_limit
      if FeedActivity.by_ip(request.ip).by_url(request.url).in_past(1.hour).count > ENV["topic_requests_per_hour"].to_i
        render json: {error: "Limit Reached" }, status: 429
      end
    end

    private def set_activity
      FeedActivity.create(ip: request.ip, url: request.url)
    end

  end
end
