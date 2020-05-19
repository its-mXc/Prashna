class User < ApplicationRecord
  #FIXME_AB: add required indexes
  enum user_type: { user: 0, admin: 1 }

  has_secure_password


  validates :email, presence: true
  validates :email, uniqueness: {case_sensitive: false}, if: -> { email.present? }
  validates :followers_count, numericality: { greater_than_or_equal_to: 0 }
  validates :password, length: {minimum: 6}, unless: -> { password.blank? }
  validates :password, presence: true, on: :password_entered
  validates :name, presence: true
  validates :password, format: { with: REGEXP[:password_format], message: "should have at-least one number, one uppercase character, one lowercase character and one special character." }, unless: -> { password.blank? }



  has_one_attached :avatar

  #FIXME_AB: use with_options dependent: destroy do .. end
  with_options dependent: :destroy do |assoc|
    assoc.has_many :comments
    assoc.has_many :user_topics
    assoc.has_many :notifications
    assoc.has_many :topics, through: :user_topics

  end
  with_options dependent: :restrict_with_error do |assoc|
    assoc.has_many :credit_transactions
    assoc.has_many :reactions
    assoc.has_many :questions
  end

  before_create :generate_confirmation_token
  after_commit :send_confirmation_mail, on: :create

  def verify!
    unless self.verified_at
      credit_transactions.create(amount: ENV['signup_credits'].to_i, transaction_type: CreditTransaction.transaction_types["signup"])
      self.verified_at = Time.current
      self.confirmation_token = nil
      save
    end
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
    #FIXME_AB: if while debiting we save -ve amount then we can do reload.credit_transactions.sum(:amount)
    self.credit_balance = reload.credit_transactions.sum(:amount)
    save!
  end

  #FIXME_AB: mark_notification_viewed! rename
  def mark_notification_viewed(notificable)
    notification = notifications.find_by(notificable: notificable)
    if notification
      notification.mark_viewed!
    end
  end

end
