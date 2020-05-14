class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  before_action :ensure_logged_in, only:[:current_user_profile, :set_avatar, :set_topics]
  before_action :ensure_not_logged_in, only:[:new, :create, :verify]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save(context: :password_entered)
        format.html { redirect_to login_path, notice: t('confirmation_mail_sent_message') }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
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
      if user.verified?
        redirect_to login_path, notice: "Welcome to the Pransh! Your email is already confirmed. Please sign in to continue."
      else
        user.verify!
        redirect_to login_path, notice: "Welcome to the Pransh! Your email has been confirmed. Please sign in to continue."
      end
    else
      redirect_to login_path, notice: "Sorry. User does not exist"
    end
  end


  def set_avatar
    current_user.avatar = user_params[:avatar]
    current_user.save
    redirect_to my_profile_path
  end

  def set_topics
    topic_names = user_params[:topic_names].split(",").map(&:strip)
    current_user.topics = Topic.where(name: topic_names)
    if topic_names.any?
      redirect_to my_profile_path, notice: "Topics added to user"
    else
      redirect_to my_profile_path, notice: "Topics Removed"
    end
  end

  #FIXME_AB: this should be nested route/ resource for user
  #FIXME_AB: ajax polling should be for logged in user only
  

  private def set_user
      @user = User.find(params[:id])
      #FIXME_AB: what if user not found
    end

  private def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email, :avatar, :topic_names)
    end
end
