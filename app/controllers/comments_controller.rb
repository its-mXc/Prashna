class CommentsController < ApplicationController
  #FIXME_AB: need user to be logged in
  before_action :find_commentable, :ensure_logged_in

    def new
      @comment = Comment.new
    end

    def create
      puts comment_params
      @comment = @commentable.comments.new(comment_params)
      @comment.user = current_user

      if @comment.save
        #FIXME_AB: I18n
        redirect_back fallback_location: root_path, notice: "Comment Posted sucessfully"
      else
        p @comment.errors
        redirect_back fallback_location: root_path, notice: "Minimum #{ENV["comment_word_length"]} words required for comment"
      end
    end


    #FIXME_AB: use inline private

    private def comment_params
      params.require(:comment).permit(:body)
    end

    def find_commentable
      #FIXME_AB: check and fixe
      if params[:comment_id]
        @commentable = Comment.find_by_id(params[:comment_id])
      elsif params[:question_id]
        @commentable = Question.find_by_url_slug(params[:question_id]) 
      end 
    end
  end
