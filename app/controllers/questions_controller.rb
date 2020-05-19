class QuestionsController < ApplicationController
  #FIXME_AB: need to change a few
  before_action :ensure_logged_in, except: :show
  before_action :ensure_valid_commit_values, only: [:create, :update]
  before_action :find_published_question, only: [:show, :reaction]
  before_action :find_question, only: [:edit, :update, :publish]
  before_action :ensure_has_not_been_interacted, only: [:edit, :update]
  before_action :ensure_is_author_of_question, only: [:edit, :update, :publish]
  before_action :ensure_has_not_been_published, only: [:publish]
  before_action :ensure_positive_balance, only: :publish
  before_action :ensure_not_voting_own_question, only: :reaction

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.new(question_params)

    #FIXME_AB: before action to validate commit values
    if params[:commit] == "Publish"
      @question.status = Question.statuses["published"]
    else
      @question.status = Question.statuses["draft"]
    end

    respond_to do |format|
      if @question.save
        if @question.draft?
          format.html { redirect_to drafts_questions_path, notice: t('.saved_to_draft') }
        elsif @question.published?
          format.html { redirect_to publish_question_path(@question.id), notice: t('.question_posted') }
        end
      else
        #FIXME_AB: topics field should be filled with entered values
        format.html { render :new }
      end
    end
  end

  def show
    if logged_in?
      current_user.mark_notification_viewed(@question)
    end

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def edit
  end

  #FIXME_AB: try to split it in three actions. one for each :commit value: update, publish, draft
  #FIXME_AB: make conditional routing whcih will use appropirate actoin based on :commit value
  def update
    #FIXME_AB: before actions to validate commit values
    if @question.update(question_params)
      if params[:commit] == "Update"
        @question.generate_url_slug
        redirect_to @question, notice: t('.question_updated')
      elsif params[:commit] == "Publish"
        redirect_to publish_question_path(@question)
      # elsif params["commit"] == "Draft"
      #   redirect_to drafts_questions_path, notice: t('.draft_changed')
      end
    else
      respond_to do |format|
        format.html {render :edit}
      end
    end

  end

  def drafts
    @drafts = current_user.questions.draft
  end

  def publish
    @question.mark_published!
    redirect_to question_path(@question), notice: t('.question_posted')
  end

  #FIXME_AB: same
  def reaction
    @question.record_reaction(params[:commit], current_user)
    redirect_to @question, notice: t('.reaction_submitted')
  end

  private def ensure_positive_balance
    unless current_user.credit_balance >= ENV['question_post_debit'].to_i
      @question.status = Question.statuses["draft"]
      @question.save
      redirect_to my_profile_path, notice: t('.no_credit_saved_to_draft')
    end
  end

  private def find_published_question
    @question = Question.published.find_by_url_slug(params[:id])
    unless @question
      redirect_to my_profile_path, notice: t('.cannot_find_question')
    end
  end

  private def ensure_is_author_of_question
    unless @question.user == current_user
      redirect_to my_profile_path, notice: t('.not_author')
    end
  end

  private def ensure_has_not_been_interacted
    if @question.interacted?
      redirect_to @question, notice: t('.cannot_edit')
    end
  end


  #FIXME_AB: find_question
  private def find_question
    #FIXME_AB: it can fire two queries, can be done in one. Use .or
    # @question = Question.where(id: params[:id]).or(Question.where(url_slug: params[:id]))
    @question = Question.find_by_id(params[:id])

    unless @question
      @question = Question.find_by_url_slug(params[:id])
    end

    unless @question
      redirect_to my_profile_path, notice: t('.cannot_find_question')
    end

  end

  private def ensure_has_not_been_published
    if @question.url_slug
      redirect_to @question, notice: t('.already_published')
    end
  end

  private def ensure_valid_commit_values
    unless params[:commit] == "Publish" || params[:commit] == "Update" || params[:commit] == "Draft"
      redirect_back fallback_location: root_path, notice: t('.invalid_commmit_params')
    end
  end

  private def ensure_not_voting_own_question
    if current_user == @question.user
      redirect_to @question, notice: t('.cannot_vote_own_question')
    end
  end


  private def question_params
    topic_names = params[:question][:topic_names].split(",").map(&:strip)
    params[:question][:topic_ids] = Topic.where(name: topic_names).map(&:id)

    params.require(:question).permit(:title, :content,:pdf_file, topic_ids: [])
  end
end
