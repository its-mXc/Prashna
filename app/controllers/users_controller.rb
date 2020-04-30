class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  before_action :ensure_logged_in, only:[:current_user_profile, :set_avatar, :set_topics]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        #FIXME_AB: use I18n for messages.
        format.html { redirect_to login_path, notice: t('confirmation_mail_sent_message') }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        #FIXME_AB: read about status: :unprocessable_entity
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def current_user_profile
    current_user
  end


  def verify
    user = User.find_by(confirmation_token: params[:token])
    if user
      user.verify!
      redirect_to login_path, notice: "Welcome to the Pransh! Your email has been confirmed.
      Please sign in to continue."
    else
      redirect_to login_path, notice: "Sorry. User does not exist"
    end
  end


  def set_avatar
    user = current_user
    user.avatar = user_params[:avatar]
    #FIXME_AB: wrap user.save in if else and redirect with alert message accordingly
    user.save(validate: false)
    p user.errors
    redirect_to my_profile_path
  end

  def set_topics
    user = current_user
    user.topic_ids = user_params[:topic_ids][1..-1]
  end

  private def set_user
      @user = User.find(params[:id])
      #FIXME_AB: what if user not found
    end

  private def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email, :avatar, topic_ids: [])
    end
end
