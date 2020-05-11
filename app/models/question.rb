class Question < ApplicationRecord
  belongs_to :user

  validates :title, uniqueness: {case_sensitive: true}
  validates :content, presence: true

  has_one_attached :pdf_file
  #FIXME_AB: dependent?
  has_many :question_topics
  has_many :topics, through: :question_topics
  #FIXME_AB: dependent?
  has_many :question_reactions
  #FIXME_AB: dependent?
  has_many :comments, as: :commentable

  before_create :generate_url_slug
  #FIXME_AB: should be done in after save. See my comment in the create_question_transaction method
  after_commit :create_question_transaction
  after_commit :generate_notifications, if: -> { self.published? }

  enum status: {draft:0, published:1}

  scope :drafts , -> { where(status:Question.statuses["draft"]) }

  private def generate_url_slug
    #FIXME_AB: slug url should  be unique. what if same slug already exists. This can happen if we remove title's uniqueness. So, if this generated slug exists, then append a random number .
    #FIXME_AB: What if there are special characters in title. You should also replace special chars with hyphen
    self.url_slug = title.downcase.gsub(" ", "-")
  end

  def to_param
    url_slug
  end

  #FIXME_AB: should be private
  def create_question_transaction
    #FIXME_AB: what if user don't have required credit balance. Have a validatoin to check that user should have required credits
    credit_trasnaction = user.credit_transactions.new(amount: ENV['question_post_debit'].to_i)
    credit_trasnaction.transaction_type = CreditTransaction.transaction_types["debit"]
    #FIXME_AB: what if following save failed due to some error. question should not be saved. Display error.
    credit_trasnaction.save
  end

  def generate_notifications
    self.topics.map(&:users).flatten.uniq.each do |user|
      if user != self.user
        notification = user.notifications.new
        notification.question = self
        notification.save
      end
    end
  end

  def interacted?
    if self.question_reactions.any?
      return true
    end
    if self.comments.any?
      return true
    end
    return false
  end

  def topic_names
    self.topics.map(&:name)
  end
end
