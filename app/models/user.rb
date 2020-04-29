class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar

  validates :email, uniqueness: {casesensitive: false}
  validates :followers_count, numericality: { greater_than_or_equal_to: 0 }
  #FIXME_AB: password length validations

  has_many :user_topics , dependent: :destroy
  has_many :topics, through: :user_topics

  before_create :generate_confirmation_token

  def email_activate
    unless self.email_confirmed
      #FIXME_AB: verified_at = Time.current
      self.email_confirmed = true
      #FIXME_AB: we would need credit_transations table and corrosponding Model.
      #FIXME_AB: rename it to credit_balance, we will never be updatign this value directly. it will be automatically updated everytime a new entry is created in the credit_transations table for the user
      self.credit = 5
      #FIXME_AB: don't need to skip validations
      save!(:validate => false)
    end
  end

  private  def generate_confirmation_token
    #FIXME_AB: you can ignore this if condition
    #FIXME_AB: now onwards, lets not use inline if-unless
    #FIXME_AB: add uniqueness validation
      self.confirm_token = SecureRandom.urlsafe_base64.to_s if self.confirm_token.blank?
    end

end
