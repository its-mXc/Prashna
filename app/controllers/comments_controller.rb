class CommentsController < ApplicationController

  before_action :find_commentable

    def new
      @comment = Comment.new
    end

    def create
      @comment = @commentable.comments.new(comment_params)

      if @comment.save
        redirect_back fallback_location: root_path, notice: "Question Posted sucessfully"
      else
        redirect_back fallback_location: root_path, notice: "Question Posted sucessfully"
      end
    end

    private

    def comment_params
      params.require(:comment).permit(:body)
    end

    def find_commentable
      @commentable = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
      @commentable = Question.find_by_url_slug(params[:question_id]) if params[:question_id]
    end
  end