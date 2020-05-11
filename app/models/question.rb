class Question < ApplicationRecord
  belongs_to :user

  validates :title, uniqueness: {case_sensitive: true}
  validates :content, presence: true

  has_one_attached :pdf_file
  has_many :question_topics
  has_many :topics, through: :question_topics
  has_many :question_reactions
  has_many :comments, as: :commentable
  
  before_create :generate_url_slug
  after_commit :create_question_transaction
  after_commit :generate_notifications, if: -> { self.published? }

  enum status: {draft:0, published:1}

  scope :drafts , -> { where(status:Question.statuses["draft"]) }

  private def generate_url_slug
    self.url_slug = title.downcase.gsub(" ", "-")  
  end

  def to_param
    url_slug
  end

  def create_question_transaction
    credit_trasnaction = user.credit_transactions.new(amount: ENV['question_post_debit'].to_i)
    credit_trasnaction.transaction_type = CreditTransaction.transaction_types["debit"]
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
