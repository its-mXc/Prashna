module Admin
  class AnswersController < AdminController

    before_action :find_answer, only: [:unpublish]
    before_action :answer_not_unpublished, only: [:unpublish]

    def unpublish
      @answer.published = false
      if @answer.popularity_credits_granted?
        @answer.popularity_credits_granted = false
        @answer.revert_credits
      end
      if @answer.save
        redirect_to admin_answers_path, notice: "Answer unpublished"
      else
        redirect_to admin_answers_path, notice: "Answer could not be unpublished"
      end
    end

    private def find_answer
      @answer = Answer.find_by(id: params[:id])
      unless @answer
        redirect_to admin_answers_path, notice: "Answer doesnt exist"
      end
    end

    private def answer_not_unpublished
      unless @answer.published
        redirect_to admin_answers_path, notice: "Already unpublished"
      end
    end
    
  end
end 