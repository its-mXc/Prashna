class QuestionReaction < ApplicationRecord
  belongs_to :user
  belongs_to :question

  enum reaction_type: {upvote:0, downvote:1}
  after_commit :set_question_reaction_count

  scope :upvotes, -> {where(reaction_type: QuestionReaction.reaction_types["upvote"])}
  scope :downvotes, -> {where(reaction_type: QuestionReaction.reaction_types["downvote"])}

  #FIXME_AB:  have a validation that one user can have one entry for one question

  private def set_question_reaction_count
    self.question.refresh_votes!
  end

  #FIXME_AB: Its better to to rename this model to Reaction and make it polymorphic so that same model can be used for votes for answers and comments
end
