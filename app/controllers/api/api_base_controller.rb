module Api
  class ApiBaseController < ActionController::Base
    before_action :set_default_response_format
    helper_method :current_user_from_token

    protected def set_default_response_format
      request.format = :json
    end

    def current_user_from_token(token)
      User.find_by_auth_token(params[:auth_token])
    end
  end
end