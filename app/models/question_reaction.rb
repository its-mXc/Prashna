class QuestionReaction < ApplicationRecord
  belongs_to :user
  belongs_to :question

  enum reaction_type: {upvote:0, downvote:1}
  after_commit :set_question_reaction_count

  scope :upvotes, -> {where(reaction_type: QuestionReaction.reaction_types["upvote"])}
  scope :downvotes, -> {where(reaction_type: QuestionReaction.reaction_types["downvote"])}


  private def set_question_reaction_count
    self.question.refresh_votes!
  end
end
