class CommentsController < ApplicationController
  before_action :ensure_logged_in
  before_action :find_commentable_and_question, only: [:new, :create]
  before_action :find_comment, only: [:reaction, :show]
  before_action :ensure_not_voting_own_comment, only: :reaction
  before_action :validate_commit_param, only: :reaction

  def new
    @comment = Comment.new
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.question = @question

    if @comment.save
      redirect_back fallback_location: root_path, notice: t('.comment_posted')
    else
      redirect_back fallback_location: root_path, notice: t('.minimum_words')
    end
  end

  def show
    current_user.mark_notification_viewed(@comment)
    redirect_to "#{question_path(@comment.question)}#comment-#{@comment.id}"
  end

  def reaction
    @comment.record_reaction(params[:commit], current_user)
    redirect_back fallback_location: root_path, notice: t('.reaction_submitted')
  end


  private def comment_params
    params.require(:comment).permit(:body)
  end

  private def find_commentable_and_question
    if params[:comment_id]
      @commentable = Comment.find_by_id(params[:comment_id])
      @question = @commentable.question
    elsif params[:question_id]
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

  private def ensure_not_voting_own_comment
    if current_user == @comment.user
      redirect_back fallback_location: root_path, notice: t('.cannot_vote_own_comment')
    end
  end

  private def validate_commit_param
    unless params[:commit] == "upvote" || params[:commit] == "downvote"
      redirect_back fallback_location: root_path, notice: t('.invalid_commmit_params')
    end
  end

end
