# == Schema Information
#
# Table name: users
#
#  id                       :bigint           not null, primary key
#  name                     :string(255)
#  password_digest          :string(255)
#  email                    :string(255)
#  user_type                :integer          default("user")
#  credit_balance           :integer          default(0)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  verified_at              :datetime
#  confirmation_token       :string(255)
#  password_reset_token     :string(255)
#  password_token_expire_at :datetime
#  auth_token               :string(255)
#  stripe_id                :string(255)
#  disabled                 :boolean          default(FALSE)
#
class User < ApplicationRecord
  enum user_type: { user: 0, admin: 1 }

  has_secure_password


  validates :email, presence: true
  validates :email, uniqueness: {case_sensitive: false}, if: -> { email.present? }
  validates :password, length: {minimum: 6}, unless: -> { password.blank? }
  validates :password, presence: true, on: :password_entered
  validates :name, presence: true
  validates :password, format: { with: REGEXP[:password_format], message: "should have at-least one number, one uppercase character, one lowercase character and one special character." }, unless: -> { password.blank? }
  validates :auth_token, uniqueness: {case_sensitive: false}, if: -> { auth_token.present? }


  has_one_attached :avatar
  has_many :transactions, as: :transactable
  with_options dependent: :destroy do |assoc|
    assoc.has_many :comments
    assoc.has_many :user_topics
    assoc.has_many :notifications
    assoc.has_many :topics, through: :user_topics
    assoc.has_many :answers
    assoc.has_many :user_follows, foreign_key: "follower_id"
    assoc.has_many :reverse_user_follows, foreign_key: "followed_id", class_name: "UserFollow"
  end
  has_many :followed_users, through: :user_follows, source: :followed
  has_many :followers, through: :reverse_user_follows


  with_options dependent: :restrict_with_error do |assoc|
    assoc.has_many :credit_transactions
    assoc.has_many :reactions
    assoc.has_many :questions
    assoc.has_many :payment_transactions
  end

  before_create :generate_confirmation_token
  after_commit :send_confirmation_mail, on: :create

  scope :verified, -> { where.not(verified_at: nil) }
  scope :without_authtoken, -> { where(auth_token: nil) }

  def verify!
    unless self.verified_at
      credit_transactions.create(amount: ENV['signup_credits'].to_i, transaction_type: CreditTransaction.transaction_types["signup"], transactable: self)
      self.verified_at = Time.current
      self.confirmation_token = nil
      #FIXME_AB: make this a function
      generate_auth_token
      save!
    end
  end
  
  def generate_auth_token
    self.auth_token = SecureRandom.urlsafe_base64.to_s
  end

  def generate_password_token
    self.password_reset_token = SecureRandom.urlsafe_base64.to_s
    self.password_token_expire_at = Time.current + ENV['password_token_expiry_time'].to_i.hours
    self.save
  end

  def verified?
    !!self.verified_at
  end

  private def send_confirmation_mail
    if self.user?
      UserMailer.send_confirmation_mail(self.id).deliver_later
    end
  end

  private  def generate_confirmation_token
      self.confirmation_token = SecureRandom.urlsafe_base64.to_s
  end

  def expire_password_token
    self.password_reset_token  = nil
    self.password_token_expire_at = nil
    self.save
  end

  def refresh_credits!
    self.credit_balance = reload.credit_transactions.sum(:amount)
    save!
  end

  def mark_notification_viewed(notificable)
    notification = notifications.find_by(notificable_type: notificable.class.name, notificable_id: notificable.id)
    if notification
      notification.mark_viewed!
    end
  end

  def following?(other_user)
    user_follows.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    user_follows.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    user_follows.find_by_followed_id(other_user.id).destroy!
  end

  def followed_users_questions
    Question.published.by_users(followed_users).includes([:reactions, :topics, :file_attachment]).order(published_at: :desc)
  end

end
