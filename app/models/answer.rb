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
    #FIXME_AB: credit_transactions.popular.order.....
    popular_transaction = CreditTransaction.popular.order(id: :desc).find_by(transactable: self)

    if self.reaction_count >= ENV["popular_question_votes"].to_i
      if popular_transaction
        if CreditTransaction.revert.find_by(transactable: popular_transaction)
          credit_transactions.create(user: user, transaction_type: CreditTransaction.transaction_types["popular"], amount: ENV["popular_question_credits"].to_i)
        end
      else
        credit_transactions.create(user: user, transaction_type: CreditTransaction.transaction_types["popular"], amount: ENV["popular_question_credits"].to_i)
      end
    else
      if popular_transaction
        unless CreditTransaction.revert.find_by(transactable: popular_transaction)
          popular_transaction.reverse_transaction
        end
      end
    end
    user.refresh_credits!
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
