class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    
    respond_to do |format|
      if @user.save
        UserMailer.send_confirmation_mail(@user).deliver_later
        format.html { redirect_to login_path, notice: 'Check you email for confirmation mail' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
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
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
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
    user = User.find(params[:id])
    user.avatar = user_params[:avatar]
    user.save
    redirect_to user
  end

  def set_topics
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
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email, :user_type, :credit, :followers_count, :avatar, topic_ids: [])
    end
end
