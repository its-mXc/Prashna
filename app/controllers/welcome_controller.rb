class WelcomeController < ApplicationController

  def index
    @questions = Question.paginate(page: params[:page], per_page: 5).published
  end
end
