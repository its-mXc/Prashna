class AnswersController < ApplicationController
  before_action :ensure_logged_in
  #FIXME_AB: published question for new and reaction also
  before_action :find_published_question, only: :create
  #FIXME_AB: new
  before_action :ensure_has_not_been_already_answered, only: :create
  before_action :find_answer, only: [:reaction, :show]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question, notice: "Answer posted"
    end
  end

  #FIXME_AB: before actoin for published
  def show
    redirect_to "#{question_path(@answer.question)}#answer-#{@answer.id}"
  end

  #FIXME_AB: before actoin for published
  def reaction
    @answer.record_reaction(params[:commit], current_user)
    render json: { reactable: @answer, timestamp: Time.current }
    # redirect_back fallback_location: root_path, notice: t('.reaction_submitted')
  end

  private def find_published_question
    #FIXME_AB: published scope
    @question = Question.find_by(url_slug: params[:question_id])
    unless @question
      redirect_back fallback_location: root_path, notice: "Cannot find published question"
    end
  end

  private def ensure_has_not_been_already_answered
    #FIXME_AB: find_by(user: current_user)
    if @question.answers.find_by(user_id: current_user.id)
      redirect_to @question, notice: "Already answered"
    end
  end

  private def find_answer
    @answer = Answer.find_by(id: params[:id])
    unless @answer
      redirect_back fallback_location: root_path, notice: "Cannot find answer"
    end
  end

  private def answer_params
    params.require(:answer).permit(:body)
  end
end
