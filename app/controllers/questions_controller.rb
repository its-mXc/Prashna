  class QuestionsController < ApplicationController
    VALID_COMMIT_BUTTON_VALUES = [:Publish, :Update, :Draft]

    before_action :ensure_logged_in, except: [:show, :search]
    before_action :ensure_valid_commit_values, only: [:create, :update, :draft_update, :draft_publish_update]
    before_action :find_published_question, only: [:show, :reaction, :update, :report_abuse]
    before_action :find_question, only: [:edit, :draft_update, :draft_publish_update, :publish]
    before_action :ensure_is_author_of_question, only: [:edit, :update, :publish, :draft_update, :draft_publish_update]
    before_action :ensure_has_not_been_interacted, only: [:edit, :update]
    before_action :ensure_has_not_been_published, only: [:publish]
    before_action :ensure_positive_balance, only: :publish
    before_action :ensure_not_voting_own_question, only: :reaction
    before_action :ensure_not_reporting_own_question, only: :report_abuse

    def new
      @question = current_user.questions.new
    end

    def create
      @question = current_user.questions.new(question_params)

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

    def update
      if @question.update(question_params)
        @question.generate_url_slug
        redirect_to @question, notice: t('.question_updated')
      else
        respond_to do |format|
          format.html {render :edit}
        end
      end
    end


    def draft_update
      if @question.update(question_params)
        redirect_to drafts_questions_path, notice: t('.draft_changed')
      else
        respond_to do |format|
          format.html {render :edit}
        end
      end
    end

    def draft_publish_update
      if @question.update(question_params)
        redirect_to publish_question_path(@question)
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

    def reaction
      @question.record_reaction(params[:commit], current_user)
      render json: { reactable: @question, timestamp: Time.current }
      # redirect_back fallback_location: root_path, notice: t('.reaction_submitted')
    end

    def search
      @questions = Question.search(question_params[:search])
    end

    def report_abuse
      abuse_report = @question.abuse_reports.new(user: current_user, details: params[:abuse_report][:details] )
      if abuse_report.save
        redirect_to @question, notice: t('.abuse_reported')
      else
        redirect_to @question, notice: t('.abuse_already_reported')
      end
    end

    private def ensure_positive_balance
      unless current_user.credit_balance >= ENV['question_post_debit'].to_i
        @question.status = Question.statuses["draft"]
        @question.save
        redirect_to my_profile_path, notice: t('.no_credit_saved_to_draft')
      end
    end

    private def find_published_question
      @question = Question.published.includes([:user]).find_by_url_slug(params[:id])
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


    private def find_question
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
      if VALID_COMMIT_BUTTON_VALUES.exclude?(params[:commit].to_sym)
        redirect_back fallback_location: root_path, notice: t('.invalid_commmit_params')
      end
    end

    private def ensure_not_voting_own_question
      if current_user == @question.user
        redirect_back fallback_location: @question, notice: t('.cannot_vote_own_question')
      end
    end
    
    private def ensure_not_reporting_own_question
      if current_user == @question.user
        redirect_back fallback_location: @question, notice: t('.cannot_report_own_question')
      end
    end


    private def question_params

      if  params[:question][:topic_names]
        topic_names = params[:question][:topic_names].split(",").map(&:strip)

        topics = []
        topic_names.each do |topic_name|
          topic = Topic.find_or_create_by(name: topic_name)
          unless topic.errors.any?
            topics << topic
          end
        end

        params[:question][:topic_ids] = topics.map(&:id)
      end

      params.require(:question).permit(:title, :content,:file, :search, topic_ids: [])
    end
  end
