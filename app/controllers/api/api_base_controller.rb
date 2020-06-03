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


    #FIXME_AB: make method that can be used as before action, which will check users exists or not, if not then json with 403 unauthorized
    #FIXME_AB: authorize

    # private def authorize
    #   unless current_user_from_token(token)
    #     render jsons 403 {}
    #     return false
    #     end
    # end

  end
end
