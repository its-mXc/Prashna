class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :reactable, polymorphic: true

  enum reaction_type: {upvote:0, downvote:1}
  after_save :set_question_reaction_count

  scope :upvotes, -> {where(reaction_type: Reaction.reaction_types["upvote"])}
  scope :downvotes, -> {where(reaction_type: Reaction.reaction_types["downvote"])}

  validates :user_id, uniqueness: {scope: :reactable_id}

  #FIXME_AB:  have a validation that one user can have one entry for one question

  private def set_question_reaction_count
    self.reactable.refresh_votes!
  end

  #FIXME_AB: Its better to to rename this model to Reaction and make it polymorphic so that same model can be used for votes for answers and comments
end
