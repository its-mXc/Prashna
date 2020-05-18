class Comment < ApplicationRecord

  validate :parent_question_is_published
  validates :body, presence: true
  validates_length_of :words_in_comment, minimum: ENV["comment_word_length"].to_i

  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable
  belongs_to :commentable, polymorphic: true
  has_many :reactions, as: :reactable, dependent: :restrict_with_error

  def refresh_votes!
    self.reaction_count = reactions.upvotes.count -  reactions.downvotes.count
    save!
  end

  #FIXME_AB: since this can be reused in questions, answers, comments so lets make ReactionRecorder Concern and use it
  def record_reaction(reaction_type, user)
    comment_reaction = reactions.find_by(user: user)
    if comment_reaction
      comment_reaction.reaction_type = Reaction.reaction_types[reaction_type]
      comment_reaction.save
    else
      reactions.create(user: user, reaction_type: Reaction.reaction_types[reaction_type])
    end
  end

  private def words_in_comment
    body.scan(/\w+/)
  end

  private def parent_question_is_published
    if question.draft?
      errors.add(:base, 'Question is not published')
      throw :abort
    end
  end
end
