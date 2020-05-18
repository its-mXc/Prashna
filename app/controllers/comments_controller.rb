class CommentsController < ApplicationController
  #FIXME_AB: fix indentation in this file
  before_action :ensure_logged_in
  before_action :find_commentable_and_question, only: [:new, :create]
  before_action :find_comment, only: :reaction
    def new
      @comment = Comment.new
    end

    def create
      #FIXME_AB: remove these puts statements
      @comment = @commentable.comments.new(comment_params)
      @comment.user = current_user
      @comment.question = @question

      if @comment.save
        #FIXME_AB: I18n
        redirect_back fallback_location: root_path, notice: t('.comment_posted')
      else
        redirect_back fallback_location: root_path, notice: t('.minimum_words')
      end
    end

    def reaction
      if current_user == @comment.user
        redirect_back fallback_location: root_path, notice: t('.cannot_vote_own_comment')
      else
        #FIXME_AB: following indented code should be a sepereate method @question.record_reaction(reaction_type, user) and it should return true / false
        @comment.record_reaction(params[:commit], current_user)
        #FIXME_AB: why used .url_slug?
        redirect_back fallback_location: root_path, notice: t('.reaction_submitted')
      end
    end


    private def comment_params
      params.require(:comment).permit(:body)
    end

    #FIXME_AB: wheneve you create a method think whether it should be private or public or protected. what should be this method
    private def find_commentable_and_question
      if params[:comment_id]
        @commentable = Comment.find_by_id(params[:comment_id])
        @question = @commentable.question
      elsif params[:question_id]
        #FIXME_AB: lets allow comments only on published questions so here Question.published.find_by....
        @commentable = Question.published.find_by_url_slug(params[:question_id])
        @question = @commentable
      end
    end

    private def find_comment
      @comment = Comment.find_by(id: params[:id])
      unless @comment
        redirect_to my_profile_path, notice: t('.cannot_find_comment')
      end
    end

  end
