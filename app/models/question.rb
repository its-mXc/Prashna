class Question < ApplicationRecord
  enum status: {draft:0, published:1}

  scope :drafts , -> { where(status:Question.statuses[:draft]) }

  extend ActiveModel::Callbacks
  define_model_callbacks :mark_published, only: :before
  define_model_callbacks :mark_published, only: :after
  
  belongs_to :user
  has_one_attached :pdf_file
  has_many :question_topics, dependent: :destroy
  has_many :topics, through: :question_topics
  #FIXME_AB: dependent? restrict
  has_many :question_reactions, dependent: :destroy
  #FIXME_AB: dependent? restrict
  has_many :comments, as: :commentable, dependent: :destroy
  
  validates :title, uniqueness: {case_sensitive: true}
  validates :content, presence: true
  #FIXME_AB: slug shoudl be unique
  #FIXME_AB: also slug should have unique index
  
  validates :content, length:{ minimum: ENV["minimum_question_char_length"].to_i, maximum: ENV["maximum_question_char_length"].to_i }
  #FIXME_AB: content should be between 10 to 1000 characters.
  
  
  before_mark_published :has_needed_credit_balance
  before_mark_published :create_question_transaction
  before_mark_published :generate_url_slug

  after_mark_published :generate_notifications



  private def generate_url_slug
    #FIXME_AB: slug url should  be unique. what if same slug already exists. This can happen if we remove title's uniqueness. So, if this generated slug exists, then append a random number .
    self.url_slug = title.downcase.gsub(REGEXP[:special_characters], "-")
    if self.class.find_by_url_slug(self.url_slug)
      self.url_slug = self.url_slug + rand(100)
    end
    save
  end

  def to_param
    if self.published?
      url_slug
    else
      id
    end
    #FIXME_AB:  if url_slug exists then slug else id
  end

  private def create_question_transaction
    #FIXME_AB: what if user don't have required credit balance. Have a validation to check that user should have required credits
    #FIXME_AB: what if following save failed due to some error. question should not be saved. Display error.
    if user.credit_transactions.create(amount: ENV['question_post_debit'].to_i, transaction_type: CreditTransaction.transaction_types["debit"])
    else
      throw :abort
    end
    #FIXME_AB:  can be done in better way
    # if credit_transactions.create()
    # else
    # end
  end

  def generate_notifications
    #optimizaion: user_ids = TopicUser.where(topic_id: topic_ids).pluck(:user_id); users = User.where(id: user_ids)
    #FIXME_AB: reject self user
    self.topics.map(&:users).flatten.uniq.reject { |user| user.id == self.user.id }.each do |user|
        #FIXME_AB: make it in 3 lines
        user.notifications.create(question: self)
    end
  end

  def interacted?
    # done like this to see code coverage when we write test
    if self.question_reactions.any?
      return true
    end

    if self.comments.any?
      return true
    end

    return false
  end

  def topic_names
    #FIXME_AB: use pluck
    self.topics.pluck(:name)
  end

  def refresh_votes!
    #FIXME_AB: self.question_reactions.upvotes.count by making scopes
    self.reaction_count = self.question_reactions.upvotes.count -  question_reactions.downvotes.count
    save
  end

  def mark_published!
    run_callbacks :mark_published do
      self.status = self.class.statuses["published"]
      save
    end
  end

  def has_needed_credit_balance
    unless user.credit_balance >= ENV['question_post_debit'].to_i
      throw :abort
    end
  end
end
