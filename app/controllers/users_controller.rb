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
        format.html { redirect_to login_path, notice: t('.confirmation_mail_sent_message') }
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
        redirect_to login_path, notice: t('.already_confirmed')
      else
        user.verify!
        redirect_to login_path, notice: t('.confirmed')
      end
    else
      redirect_to login_path, notice: t('.user_doesnt_exist')
    end
  end


  def set_avatar
    current_user.avatar = user_params[:avatar]
    current_user.save
    redirect_to my_profile_path
  end

  def set_topics
    topic_names = user_params[:topic_names].split(",").map(&:strip)

    #FIXME_AB: topics = []
    topics = []
    topic_names.each do |topic_name|
      #FIXME_AB: topics << find_or_create
      topics << Topic.find_or_create_by(name: topic_name)
    end

    #FIXME_AB: you can save this query by saving all topics a local array and assign that array here current_user.topics = topics
    current_user.topics = topics
    if topic_names.any?
      redirect_to my_profile_path, notice: t('.topics_added')
    else
      redirect_to my_profile_path, notice: t('.topics_removed')
    end
  end

  private def set_user
      @user = User.find(params[:id])
      redirect_to root_path, notice: t('.user_doesnt_exist')
    end

  private def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email, :avatar, :topic_names)
    end
end
