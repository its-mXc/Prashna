class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable

  validates :body, presence: true
  validates_length_of :words_in_comment, minimum: ENV["comment_word_length"].to_i

  has_many :reactions, as: :reactable, dependent: :restrict_with_error

  #FIXME_AB: Also add a validation that if comment is being created on a question that question should be published.

  validate :parent_question_is_published

  def refresh_votes!
    self.reaction_count = reactions.upvotes.count -  reactions.downvotes.count
    save
  end

  def record_reaction(reaction_type, user)
    comment_reaction = reactions.find_by(user: user)
    if comment_reaction
      comment_reaction.reaction_type = Reaction.reaction_types[reaction_type]
      comment_reaction.save
    else
      reactions.create(user: user, reaction_type: Reaction.reaction_types[reaction_type])
    end
  end

  #FIXME_AB: should be private method
  private def words_in_comment
    body.scan(/\w+/)
  end

  private def parent_question_is_published
    unless question.published?
      errors.add(:base, 'Question is not published')
      throw :abort
    end
  end
end
