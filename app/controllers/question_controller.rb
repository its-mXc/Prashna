class QuestionController < ApplicationController
  before_action :ensure_logged_in
  def new
  end

  def create
    current_user.questions.create(question_params)
  end


  private def question_params
    params.require(:question).permit(:title, :content)
  end
end



