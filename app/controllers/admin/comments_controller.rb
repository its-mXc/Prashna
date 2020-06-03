module Admin
  class CommentsController < AdminController

    before_action :find_comment, only: [:unpublish]
    before_action :comment_not_unpublished, only: [:unpublish]

    def index
      @comments = Comment.unscoped
    end

    def unpublish
      @comment.published = false
      if @comment.save
        redirect_to admin_comments_path, notice: "Comment unpublished"
      else
        redirect_to admin_comments_path, notice: "Comment could not be unpublished"
      end
    end

    private def find_comment
      @comment = Comment.find_by(id: params[:id])
      unless @comment
        redirect_to admin_comments_path, notice: "comment doesnt exist"
      end
    end

    private def comment_not_unpublished
      unless @comment.published
        redirect_to admin_comments_path, notice: "Already unpublished"
      end
    end
    
  end
end