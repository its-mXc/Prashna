class Question < ApplicationRecord
  belongs_to :user

  validates :title, uniqueness: {case_sensitive: true}
  validates :content, presence: true

  has_one_attached :pdf_file
  has_many :question_topics
  has_many :topics, through: :question_topics
  before_create :generate_url_slug
  after_commit :create_question_transaction

  enum status: {draft:0, published:1}

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
end
