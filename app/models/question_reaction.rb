class QuestionReaction < ApplicationRecord
  belongs_to :user
  belongs_to :question

  enum reaction_type: {upvote:0, downvote:1}
  after_commit :set_question_reaction_count


  private def set_question_reaction_count
    self.question.refresh_votes!
    #FIXME_AB: will "upvote" , 'downvote' in following line work as reaction_type is enum
    #FIXME_AB: instead of doing this here. Lets make a method in questons model so that we can reuse this. @question.refresh_votes!  and call this method here. This way we have a way to refresh votes count on question from question object
  end
end
