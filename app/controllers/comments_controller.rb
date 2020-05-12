class CommentsController < ApplicationController
  #FIXME_AB: need user to be logged in
  before_action :find_commentable

    def new
      @comment = Comment.new
    end

    def create
      @comment = @commentable.comments.new(comment_params)
      @comment.user = current_user

      if @comment.save
        #FIXME_AB: I18n
        redirect_back fallback_location: root_path, notice: "Comment Posted sucessfully"
      else
        redirect_back fallback_location: root_path, notice: "Comment Posted sucessfully"
      end
    end


    #FIXME_AB: use inline private
    private

    def comment_params
      params.require(:comment).permit(:body)
    end

    def find_commentable
      #FIXME_AB: check and fixe
      @commentable = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
      @commentable = Question.find_by_url_slug(params[:question_id]) if params[:question_id]
    end
  end
