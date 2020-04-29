class ApplicationController < ActionController::Base

  #FIXME_AB: since we may need current_user in views also, we'll have to make it available to view also. Read about "helper_method" from api

  #FIXME_AB: current_user: which will find user with session_id or remember me cookie and return the user/nil
  #FIXME_AB: make sure to memoize the current_user method
end
