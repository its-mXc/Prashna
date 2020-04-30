class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar
  has_many :credit_transactions

  validates :email, uniqueness: {casesensitive: false}
  validates :followers_count, numericality: { greater_than_or_equal_to: 0 }
  validates :password, length: {minimum: 4}

  has_many :user_topics , dependent: :destroy
  has_many :topics, through: :user_topics

  before_create :generate_confirmation_token
  after_commit :send_confirmation_mail, on: :create

  def verify!
    unless self.verified_at
      self.verified_at = Time.current      
      self.credit_balance = CreditTransaction.create(user_id: self.id, amount:5, transaction_type:0, credit_balance: self.credit_balance + 5).credit_balance
      save(validate: false)
    end
  end

  private def send_confirmation_mail
    UserMailer.send_confirmation_mail(self.id).deliver_now
  end

  private  def generate_confirmation_token
      self.confirmation_token = SecureRandom.urlsafe_base64.to_s
    end

end
