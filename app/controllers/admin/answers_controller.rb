module Admin
  class AnswersController < AdminController

    before_action :find_answer, only: [:unpublish]
    before_action :answer_not_unpublished, only: [:unpublish]

    def unpublish
      if @answer.unpublish!
        redirect_back fallback_location: admin_questions_path, notice: "Answer unpublished"
      else
        redirect_back fallback_location: admin_questions_path, notice: "Answer could not be unpublished"
      end
    end

    private def find_answer
      @answer = Answer.find_by(id: params[:id])
      unless @answer
        redirect_back fallback_location: admin_questions_path, notice: "Answer doesnt exist"
      end
    end

    private def answer_not_unpublished
      unless @answer.published
        redirect_back fallback_location: admin_questions_path, notice: "Already unpublished"
      end
    end
    
  end
end 