class AdminController < ApplicationController
  before_action :ensure_logged_in
  before_action :ensure_is_admin


  private def ensure_is_admin
    unless current_user.admin?
      redirect_to my_profile_path , notice: "This is reserved for admin only"
    end
  end
end