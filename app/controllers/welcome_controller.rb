class WelcomeController < ApplicationController

  def index
    @questions = Question.with_attached_file.paginate(page: params[:page], per_page: ENV["questions_per_page"].to_i).includes(:reactions, :user, :topics, :answers, :comments).published.order(published_at: :desc)
  end
end
