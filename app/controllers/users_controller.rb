class UsersController < ApplicationController
  #FIXME_AB: before actions for loggedin and non logged in user


  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    #FIXME_AB: we don't need index
    @users = User.all
  end

  def show
    #FIXME_AB: we don't need show
    #FIXME_AB: /my_profile which will show profile of logged in user. and wont take any id
  end

  def new
    @user = User.new
  end

  def edit
    #FIXME_AB: remove
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        #FIXME_AB: mail should be sent from model after commit on create
        #FIXME_AB: instead of passing @user object pass id
        UserMailer.send_confirmation_mail(@user).deliver_later
        #FIXME_AB: use I18n for messages.
        format.html { redirect_to login_path, notice: 'Check you email for confirmation mail' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        #FIXME_AB: read about status: :unprocessable_entity
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    #FIXME_AB: For showing and updating password through password reset, make a new controller PasswordReset
    #FIXME_AB: then remove update action
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    #FIXME_AB: we don't need this
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #FIXME_AB: rename it to verify
  def confirm_email
    #FIXME_AB: params[:id] => params[:token]
    user = User.find_by_confirm_token(params[:id])
    if user
      #FIXME_AB: user.verify!
      user.email_activate
      redirect_to login_path, notice: "Welcome to the Sample App! Your email has been confirmed.\nPlease sign in to continue."
    else
      redirect_to login_path, notice: "Sorry. User does not exist"
    end
  end

  def change_password
    @user = User.find_by_confirm_token(params[:id])
  end

  def set_avatar
    #FIXME_AB: use current_user
    user = User.find(params[:id])
    user.avatar = user_params[:avatar]
    #FIXME_AB: wrap user.save in if else and redirect with alert message accordingly
    user.save
    redirect_to user
  end

  def set_topics
    #FIXME_AB: current_user
    user = User.find(params[:id])
    user.topic_ids = user_params[:topic_ids][1..-1]
  end

  def forgot_password
  end

  def reset_password
    user = User.find_by_email(user_params[:email])
    UserMailer.send_password_reset_mail(user).deliver_now
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
      #FIXME_AB: what if user not found
    end

    # Only allow a list of trusted parameters through.
    def user_params
      #FIXME_AB: remove unwanted params
      params.require(:user).permit(:name, :password, :password_confirmation, :email, :user_type, :credit, :followers_count, :avatar, topic_ids: [])
    end
end
