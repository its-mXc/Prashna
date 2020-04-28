class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar
  before_create :generate_confirmation_token
  has_many :user_topics
  has_many :topics, through: :user_topics
  validates :email, uniqueness: {casesensitive: false}
  validates :followers_count, numericality: { greater_than_or_equal_to: 0 }
  
  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(:validate => false)
  end
  
  def credit_activate
    self.credit = 5
    save!(:validate => false)
  end
  
  private
    def generate_confirmation_token
      self.confirm_token = SecureRandom.urlsafe_base64.to_s if self.confirm_token.blank?
    end
    
end