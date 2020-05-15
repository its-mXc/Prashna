class QuestionsController < ApplicationController
  before_action :ensure_logged_in
  before_action :find_editable_question, only: [:edit, :update]
  before_action :find_published_question, only: [:show, :reaction]
  before_action :ensure_has_not_been_interacted, only: [:edit, :update]
  before_action :ensure_positive_balance, only: :publish
  before_action :find_publishable_question, only: :publish
  before_action :ensure_has_not_been_published, only: [:publish]
  before_action :ensure_is_author_of_question, only: [:edit, :update, :publish]

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.new(question_params)

    #FIXME_AB: fallback should be draft.  check for published
    if params[:commit] == "Publish"
      @question.status = Question.statuses["published"]
    else
      @question.status = Question.statuses["draft"]
    end

    respond_to do |format|
      if @question.save
        if @question.draft?
          format.html { redirect_to drafts_questions_path, notice: "Saved to Drafts" }
        elsif @question.published?
          format.html { redirect_to publish_question_path(@question.id), notice: "Question posted" }
        end
      else
        format.html { render :new }
      end
    end
  end

  def show
    #FIXME_AB: what about this quesiton is a draft question? if it is a draft question then only poster can see the question. other people should not be able to see it.
    current_user.mark_notification_viewed(@question)

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def edit
    #FIXME_AB: who all can edit update question? no check?
  end

  def update
    #FIXME_AB: before actions
    if @question.update(question_params)
      @question.mark_published!
      redirect_to @question, notice: "Question updated"
    else
      respond_to do |format|
        format.html {render :edit}
      end
    end
      
  end

  def drafts
    @drafts = current_user.questions.drafts
  end

  def publish
    #FIXME_AB: we need to ensure that question is currently in draft before publish
    #FIXME_AB: who can publish a question, anybody? no check
    @question.mark_published!
    redirect_to question_path(@question), notice: "Question Posted"
  end
  
  def reaction
    if current_user == @question.user
      redirect_to @question, notice: "Cannot vote your own question"
    else
      #FIXME_AB: following indented code should be a sepereate method @question.record_reaction(reaction_type, user) and it should return true / false
      question_reaction = @question.question_reactions.find_by(user: current_user)
      if question_reaction
        question_reaction.reaction_type = QuestionReaction.reaction_types[params[:commit]]
        question_reaction.save
      else
        @question.question_reactions.create(user:current_user, reaction_type: QuestionReaction.reaction_types[params[:commit]])
      end
      #FIXME_AB: why used .url_slug?
      redirect_to @question, notice: "Reaction Submitted"
    end
  end
  
  
  
  private def ensure_positive_balance
    unless current_user.credit_balance >= ENV['question_post_debit'].to_i
      #FIXME_AB: lets start using I18n everywhere
      redirect_to my_profile_path, notice: "No credit avaliable. Purchase more"
    end
  end
  
  private def find_published_question
    #FIXME_AB: finding published question, hence Question.published.find...
    @question = Question.published.find_by_url_slug(params[:id])
    unless @question
      redirect_to my_profile_path, notice: "No such question exist"
    end
  end
  
  private def ensure_is_author_of_question
    unless @question.user == current_user
      redirect_to my_profile_path, notice: "You are not the author for the question"
    end
  end
  
  private def ensure_has_not_been_interacted
    if @question.interacted?
      redirect_to question_path(@question.url_slug), notice: "Cannot edit, has  been interacted"
    end
  end
  
  private def find_publishable_question
    @question = Question.find_by_id(params[:id])
    unless @question
      @question = Question.find_by_url_slug(params[:id])
      ensure_has_not_been_published
    end
  end

  private def find_editable_question
    @question = Question.find_by_id(params[:id])
    unless @question
      @question = Question.find_by_url_slug(params[:id])
    end
  end

  private def ensure_has_not_been_published
    if @question.url_slug
      redirect_to @question, notice: "Already been published"
    end
  end

  private def question_params
    topic_names = params[:question][:topic_names].split(",").map(&:strip)
    params[:question][:topic_ids] = Topic.where(name: topic_names).map(&:id)

    params.require(:question).permit(:title, :content,:pdf_file, topic_ids: [])
  end
end
