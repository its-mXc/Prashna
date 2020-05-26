class Answer < ApplicationRecord
  include ReactionRecorder

  validates :body, presence: true
  validates :question_id, uniqueness: { scope: :user_id }
  validate :question_is_published

  belongs_to :user
  belongs_to :question
  has_many :reactions, as: :reactable, dependent: :restrict_with_error
  has_many :comments, as: :commentable, dependent: :restrict_with_error
  
  after_create :notify_question_author

  scope :order_by_vote, -> {order(reaction_count: :desc)}

  def refresh_votes!
    self.reaction_count = reactions.upvotes.count -  reactions.downvotes.count
    check_popularity
    save!
  end

  private def check_popularity
    if self.reaction_count >= ENV["popular_question_votes"].to_i
      unless PopularQuestion.find_by(answer: self)
        transaction = CreditTransaction.create(user: self.user, transaction_type: CreditTransaction.transaction_types["popular"], amount: ENV["popular_question_vcredits"].to_i)
        PopularQuestion.create(credit_transaction_id: transaction.id, answer: self)
        user.refresh_credits!
      end
    else
      if PopularQuestion.find_by(answer: self)
        PopularQuestion.find_by(answer: self).destroy
      end
    end
  end


  private def question_is_published
    if question.draft?
      errors.add(:base, "Parent question is not published")
      throw :abort
    end
  end

  private def notify_question_author
    unless question.user == user
      UserMailer.send_question_answered_mail(self.id).deliver_later
    end
  end
end