class Reaction < ApplicationRecord
  enum reaction_type: { upvote: 0, downvote: 1 }

  validates :user_id, uniqueness: { scope: [:reactable_id, :reaction_type] }

  belongs_to :user
  belongs_to :reactable, polymorphic: true

  after_save :set_reactable_reaction_count

  scope :upvotes, -> { where(reaction_type: Reaction.reaction_types["upvote"]) }
  scope :downvotes, -> { where(reaction_type: Reaction.reaction_types["downvote"]) }


  private def set_reactable_reaction_count
    reactable.refresh_votes!
  end

end
