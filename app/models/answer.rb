class Answer < ApplicationRecord
  include ReactionRecorder

  validates :body, presence: true
  validates :question_id, uniqueness: { scope: :user_id }
  validate :question_is_published

  belongs_to :user
  belongs_to :question
  has_many :reactions, as: :reactable, dependent: :restrict_with_error
  has_many :comments, as: :commentable, dependent: :restrict_with_error
  has_many :credit_transactions, as: :transactable

  after_commit :notify_question_author, on: :create

  scope :order_by_vote, -> {order(reaction_count: :desc)}

  #FIXME_AB: lets add a boolean field, default false, popularity_credits_granted
  def refresh_votes!
    self.reaction_count = reactions.upvotes.count -  reactions.downvotes.count
    #FIXME_AB: adjust_popularity_credits
            # if popularity_credits_granted && current_votes < required_votes
            #   take credits back
            #   popularity_credits_granted = false
            # end

            # if popularity_credits_granted == false && current_votes >= required_votes
            #   give credits
            #   popularity_credits_granted =true
            # end


    check_popularity
    save!
  end

  #FIXME_AB:  need to update
  private def check_popularity
    if reaction_count >= ENV["popular_question_votes"].to_i && !popularity_credits_granted
      grant_credits
      self.popularity_credits_granted = true
    end
    
    if reaction_count < ENV["popular_question_votes"].to_i && popularity_credits_granted
      revert_credits
      self.popularity_credits_granted = false
    end

    save
    #FIXME_AB: credit_transactions.popular.order.....

  end

  private def grant_credits
    credit_transactions.create(user: user, transaction_type: CreditTransaction.transaction_types["popular"], amount: ENV["popular_question_credits"].to_i)
  end

  private def revert_credits
    credit_transactions.popular.last.reverse_transaction
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
