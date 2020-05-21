class WelcomeController < ApplicationController

  def index
    @questions = Question.paginate(page: params[:page], per_page: 5).published.order(published_at: :desc)
  end
end
