class QuestionReaction < ApplicationRecord
  belongs_to :user
  belongs_to :question

  enum reaction_type: {upvote:0, downvote:1}
  after_commit :set_question_reaction_count


  private def set_question_reaction_count
    self.question.refresh_votes!
  end
end
