class QuestionReaction < ApplicationRecord
  belongs_to :user
  belongs_to :question

  enum reaction_type: {upvote:0, downvote:1} 
  after_commit :set_question_reaction_count


  private def set_question_reaction_count
    question_reactions =  self.question.question_reactions
    reaction_count  = question_reactions.where(reaction_type: "upvote").count -  question_reactions.where(reaction_type: "downvote").count
    self.question.reaction_count = reaction_count
    self.question.save
  end
end
