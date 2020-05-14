class CommentsController < ApplicationController
  #FIXME_AB: fix indentation in this file
  before_action :find_commentable, :ensure_logged_in

    def new
      @comment = Comment.new
    end

    def create
      #FIXME_AB: remove these puts statements
      puts comment_params
      @comment = @commentable.comments.new(comment_params)
      @comment.user = current_user

      if @comment.save
        #FIXME_AB: I18n
        redirect_back fallback_location: root_path, notice: t('comment_posted_successfuly')
      else
        p @comment.errors
        redirect_back fallback_location: root_path, notice: t('comment_not_posted')
      end
    end


    private def comment_params
      params.require(:comment).permit(:body)
    end

    #FIXME_AB: wheneve you create a method think whether it should be private or public or protected. what should be this method
    def find_commentable
      if params[:comment_id]
        @commentable = Comment.find_by_id(params[:comment_id])
      elsif params[:question_id]
        #FIXME_AB: lets allow comments only on published questions so here Question.published.find_by....
        @commentable = Question.find_by_url_slug(params[:question_id])
      end
    end
  end
