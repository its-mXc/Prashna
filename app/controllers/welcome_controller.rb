class WelcomeController < ApplicationController

  def index
    #FIXME_AB: like here add eager loading to all place, take help from bullet gem
    @questions = Question.with_attached_file.paginate(page: params[:page], per_page: ENV["questions_per_page"].to_i).includes(:reactions, :user, :topics).published.order(published_at: :desc)
  end
end
