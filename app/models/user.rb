class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar

  #FIXME_AB: dependent restrict with error
  has_many :credit_transactions

  #FIXME_AB: email presence validation
  #FIXME_AB: uniquesss should run only if email is present
  #FIXME_AB: case_sensitive
  validates :email, uniqueness: {casesensitive: false}
  validates :followers_count, numericality: { greater_than_or_equal_to: 0 }
  #FIXME_AB: use if: password.present?
  validates :password, length: {minimum: 4}

  has_many :user_topics , dependent: :destroy
  has_many :topics, through: :user_topics

  before_create :generate_confirmation_token
  after_commit :send_confirmation_mail, on: :create

  def verify!
    unless self.verified_at
      #FIXME_AB: clear token
      self.verified_at = Time.current
      #FIXME_AB: use association. credit_transactions.create(amount: 5)
      #FIXME_AB: don't hardcode 5. User figaro 'signup_credits'
      #FIXME_AB: instead of using 0 for transaction type use Conversation.statuses[:active]
      #FIXME_AB: don't do credit_balance =
      self.credit_balance = CreditTransaction.create(user_id: self.id, amount:5, transaction_type:0, credit_balance: self.credit_balance + 5).credit_balance
      #FIXME_AB: dont do validate false
      save(validate: false)
    end
  end

  private def send_confirmation_mail
    #FIXME_AB: deliver_later
    UserMailer.send_confirmation_mail(self.id).deliver_now
  end

  private  def generate_confirmation_token
      self.confirmation_token = SecureRandom.urlsafe_base64.to_s
    end

end
