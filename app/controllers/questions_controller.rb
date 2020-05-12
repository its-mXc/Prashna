class QuestionsController < ApplicationController
  before_action :ensure_logged_in
  before_action :ensure_positive_balance, only:[:publish]

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.new(question_params)

    #FIXME_AB: fallback should be draft.  check for published
    if params[:commit] == "draft"
      @question.status = Question.statuses["draft"]
    else
      @question.status = Question.statuses["published"]
    end

    respond_to do |format|

      if @question.save

        if @question.draft?
          format.html { redirect_to questions_drafts_path, notice: "Saved to Drafts" }
        elsif @question.published?
          format.html { redirect_to question_publish_path(@question.id), notice: "Question posted" }
        end
        # format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    #FIXME_AB: params[:slug]
    @question = Question.find_by_url_slug(params[:id])
    #FIXME_AB: you should have a beofre action to find question by slug else redirect
    if @question.nil?
      redirect_to my_profile_path, notice: "Cannot find question"
    end

    #FIXME_AB: current_user.mark_notification_viewed(@question)

    notification = current_user.notifications.find_by(question: @question)
    if notification
      notification.viewed = true
      notification.save
    end

    respond_to do |format|
      format.html # show.html.erb
      #FIXME_AB: @product?
      format.json { render json: @product }
    end
  end

  def edit
    @question = Question.find_by_url_slug(params[:id])
    #FIXME_AB: this @question.interacted? should be checked for edit/update/destroy and should be done in before action
    if @question && @question.interacted?
      redirect_to question_path(@question.url_slug), notice: "Cannot edit, has  been interacted"
    elsif @question.nil?
      redirect_to question_new_path, notice: "No such question exist"
    end
  end

  def update
    #FIXME_AB: before actions
    @question = Question.find_by_url_slug(params[:id])
    @question.update(question_params)
    redirect_to question_path(@question.url_slug)
  end

  def drafts
    @drafts = current_user.questions.drafts
  end

  def publish
    @question = Question.find(params[:id])
    #FIXME_AB: question.mark_published!. if we do this way, we can use custom callbacks to deduct credits when publishing.
    @question.status = Question.statuses["published"]
    @question.save
    redirect_to question_path(@question.url_slug), notice: "Question Posted"
  end

  def reaction
    #FIXME_AB: refactore and write better
    @question = Question.find(params[:id])
    question_reaction = @question.question_reactions.find_by(user: current_user)
    if question_reaction
      question_reaction.reaction_type = QuestionReaction.reaction_types[params[:commit]]
      question_reaction.save
    else
      @question.question_reactions.create(user:current_user, reaction_type: QuestionReaction.reaction_types[params[:commit]])
    end
    redirect_to question_path(@question.url_slug)
  end


  private def question_params
    topic_names = params[:question][:topic_names].split(",").map(&:strip)
    params[:question][:topic_ids] = Topic.where(name: topic_names).map(&:id)

    params.require(:question).permit(:title, :content,:pdf_file, topic_ids: [])
  end

  #FIXME_AB: update
  private def ensure_positive_balance
    unless current_user.credit_balance > 0
      redirect_to my_profile_path, notice: "No credit avaliable. Purchase more"
    end
  end
end



