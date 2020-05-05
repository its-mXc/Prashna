class QuestionController < ApplicationController
  before_action :ensure_logged_in
  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.new(question_params)
    if params[:commit] = "draft"
      @question.status = 0
    else
      @question.status = 1
    end
    respond_to do |format|
      if @question.published?
        @question.topics.each do |topic|
          topic.users.each do |user|
            puts user
            notification = user.notifications.new
            notification.question = @question
            notification.save
          end
        end
      end
      if @question.save
          format.html { redirect_to my_profile_path, notice: "Question posted" }
        # format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @question = Question.find_by_url_slug(params[:id])
    p @question
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end


  private def question_params
    params.require(:question).permit(:title, :content,:pdf_file, topic_ids: [])
  end
end



