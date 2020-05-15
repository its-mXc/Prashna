class CommentsController < ApplicationController
  #FIXME_AB: fix indentation in this file
  before_action :find_commentable_and_question, :ensure_logged_in
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
        redirect_back fallback_location: root_path, notice: 'Comment Posted'
      else
        redirect_back fallback_location: root_path, notice: "Mimimum #{ENV["comment_word_length"]} words required "
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

  end
