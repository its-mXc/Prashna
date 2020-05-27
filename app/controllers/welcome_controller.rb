class WelcomeController < ApplicationController

  def index
    @questions = Question.with_attached_file.paginate(page: params[:page], per_page: 5).includes(:answers, :comments, :reactions, :user, :topics).published.order(published_at: :desc)
  end
end
