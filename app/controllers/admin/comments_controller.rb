module Admin
  class CommentsController < AdminController

    before_action :find_comment, only: [:unpublish]
    before_action :comment_not_unpublished, only: [:unpublish]

    def unpublish
      if @comment.unpublish!
        redirect_back fallback_location: admin_questions_path,notice: "Comment unpublished"
      else
        redirect_back fallback_location: admin_questions_path, notice: "Comment could not be unpublished"
      end
    end

    private def find_comment
      @comment = Comment.find_by(id: params[:id])
      unless @comment
        redirect_back fallback_location: admin_questions_path, notice: "comment doesnt exist"
      end
    end

    private def comment_not_unpublished
      unless @comment.published
        redirect_back fallback_location: admin_questions_path, notice: "Already unpublished"
      end
    end
    
  end
end