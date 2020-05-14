class QuestionsController < ApplicationController
  before_action :ensure_logged_in
  before_action :ensure_positive_balance, only: [:publish]
  before_action :find_published_question, only: [:show, :edit, :update, :reaction]

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.new(question_params)

    #FIXME_AB: fallback should be draft.  check for published
    if params[:commit] == "Save Question"
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
    #FIXME_AB: params[:slug]
    #FIXME_AB: you should have a beofre action to find question by slug else redirect
    
    #FIXME_AB: current_user.mark_notification_viewed(@question)
    current_user.mark_notification_viewed(@question)

    respond_to do |format|
      format.html # show.html.erb
      #FIXME_AB: @product?
    end
  end
  
  def edit
    #FIXME_AB: this @question.interacted? should be checked for edit/update/destroy and should be done in before action
    if @question.interacted?
      redirect_to question_path(@question.url_slug), notice: "Cannot edit, has  been interacted"
    end
  end
  
  def update
    #FIXME_AB: before actions
    if @question.update(question_params)
      redirect_to question_path(@question.url_slug)
    end
  end
  
  def drafts
    @drafts = current_user.questions.drafts
  end
  
  def publish
    @question = Question.find(params[:id])
    #FIXME_AB: question.mark_published!. if we do this way, we can use custom callbacks to deduct credits when publishing.
    @question.mark_published!
    redirect_to question_path(@question), notice: "Question Posted"
  end

  def reaction
    #FIXME_AB: refactore and write better
    if current_user == @question.user
      redirect_to question_path(@question.url_slug), notice: "Cannot vote your own question"
    else
      question_reaction = @question.question_reactions.find_by(user: current_user)
      if question_reaction
        question_reaction.reaction_type = QuestionReaction.reaction_types[params[:commit]]
        question_reaction.save
      else
        @question.question_reactions.create(user:current_user, reaction_type: QuestionReaction.reaction_types[params[:commit]])
      end
      redirect_to question_path(@question.url_slug), notice: "Reaction Submitted"
    end
  end
  
  
  
  #FIXME_AB: update
  private def ensure_positive_balance
    unless current_user.credit_balance >= ENV['question_post_debit'].to_i
      redirect_to my_profile_path, notice: "No credit avaliable. Purchase more"
    end
  end
  
  private def find_published_question
    @question = Question.find_by_url_slug(params[:id])
    unless @question
      redirect_to my_profile_path, notice: "No such question exist"
    end
  end
  
  private def question_params
    topic_names = params[:question][:topic_names].split(",").map(&:strip)
    params[:question][:topic_ids] = Topic.where(name: topic_names).map(&:id)
    
    params.require(:question).permit(:title, :content,:pdf_file, topic_ids: [])
  end
end
