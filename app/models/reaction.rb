class Reaction < ApplicationRecord
  enum reaction_type: { upvote: 0, downvote: 1 }

  validates :user_id, uniqueness: { scope: [:reactable_id, :reactable_type] }
  validate :ensure_not_reacting_to_own_reactable
  validate :ensure_question_is_published

  belongs_to :user
  belongs_to :reactable, polymorphic: true

  after_save :set_reactable_reaction_count

  scope :upvotes, -> { where(reaction_type: Reaction.reaction_types["upvote"]) }
  scope :downvotes, -> { where(reaction_type: Reaction.reaction_types["downvote"]) }


  private def set_reactable_reaction_count
    reactable.refresh_votes!
  end

  private def ensure_not_reacting_to_own_reactable
    if user == reactable.user
      errors.add(:base, "cannot vote your own reactable")
      throw :abort
    end
  end

  private def ensure_question_is_published
    #FIXME_AB: better way to do this is reactable.is_a? Question
    if reactable.is_a? Question
      if reactable.draft?
        errors.add(:base, "cannot react to unpublished question")
        throw :abort
      end
    end
  end

end
