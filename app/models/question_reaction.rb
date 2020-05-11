class QuestionReaction < ApplicationRecord
  belongs_to :user
  belongs_to :question

  enum reaction_type: {upvote:0, downvote:1}
  after_commit :set_question_reaction_count


  private def set_question_reaction_count
    question_reactions =  self.question.question_reactions
    #FIXME_AB: will "upvote" , 'downvote' in following line work as reaction_type is enum
    reaction_count  = question_reactions.where(reaction_type: "upvote").count -  question_reactions.where(reaction_type: "downvote").count
    self.question.reaction_count = reaction_count
    self.question.save
    #FIXME_AB: instead of doing this here. Lets make a method in questons model so that we can reuse this. @question.refresh_votes!  and call this method here. This way we have a way to refresh votes count on question from question object
  end
end
