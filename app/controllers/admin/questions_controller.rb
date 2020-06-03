module Admin
  class QuestionsController < AdminController

    before_action :find_question, only: [:unpublish]
    before_action :question_not_unpublished, only: [:unpublish]

    def index
      @questions = Question.published.or(Question.unpublished)
    end

    def unpublish
      @question.status  = Question.statuses["unpublished"]
      if @question.save
        redirect_to admin_questions_path, notice: "Question unpublished"
      else
        redirect_to admin_questions_path, notice: "Question could not be unpublished"
      end
    end

    private def find_question
      @question = Question.published.find_by(url_slug: params[:id])
      unless @question
        redirect_to admin_questions_path, notice: "Question doesnt exist"
      end
    end

    private def question_not_unpublished
      if @question.unpublished?
        redirect_to admin_questions_path, notice: "Already unpublished"
      end
    end
    
  end
end