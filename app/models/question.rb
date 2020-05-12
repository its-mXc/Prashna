class Question < ApplicationRecord
  enum status: {draft:0, published:1}

  belongs_to :user

  validates :title, uniqueness: {case_sensitive: true}
  validates :content, presence: true
  #FIXME_AB: slug shoudl be unique
  #FIXME_AB: also slug should have unique index

  #FIXME_AB: content should be between 10 to 1000 characters.

  has_one_attached :pdf_file
  has_many :question_topics, dependent: :destroy
  has_many :topics, through: :question_topics
  #FIXME_AB: dependent? restrict
  has_many :question_reactions, dependent: :destroy
  #FIXME_AB: dependent? restrict
  has_many :comments, as: :commentable, dependent: :destroy

  before_save :generate_url_slug, if: -> { self.published? }
  #FIXME_AB: before save.
  after_save :create_question_transaction, if: -> { self.published? }
  after_commit :generate_notifications, if: -> { self.published? }


  scope :drafts , -> { where(status:Question.statuses[:draft]) }

  private def generate_url_slug
    #FIXME_AB: slug url should  be unique. what if same slug already exists. This can happen if we remove title's uniqueness. So, if this generated slug exists, then append a random number .
    self.url_slug = title.downcase.gsub(REGEXP[:special_characters], "-")
  end

  def to_param
    #FIXME_AB:  if url_slug exists then slug else id
    url_slug
  end

  private def create_question_transaction
    #FIXME_AB: what if user don't have required credit balance. Have a validation to check that user should have required credits
    credit_trasnaction = user.credit_transactions.new(amount: ENV['question_post_debit'].to_i)
    credit_trasnaction.transaction_type = CreditTransaction.transaction_types["debit"]
    #FIXME_AB: what if following save failed due to some error. question should not be saved. Display error.
    credit_trasnaction.save

    #FIXME_AB:  can be done in better way
    # if credit_transactions.create()
    # else
    # end
  end

  def generate_notifications
    #optimization: user_ids = TopicUser.where(topic_id: topic_ids).pluck(:user_id); users = User.where(id: user_ids)
    #FIXME_AB: reject self user
    self.topics.map(&:users).flatten.uniq.each do |user|
      if user != self.user
        #FIXME_AB: make it in 3 lines
        notification = user.notifications.new
        notification.question = self
        notification.save
      end
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
    self.topics.map(&:name)
  end

  def refresh_votes!
    #FIXME_AB: self.question_reactions.upvotes.count by making scopes
    self.reaction_count = self.question_reactions.where(reaction_type: QuestionReaction.reaction_types["upvote"]).count -  question_reactions.where(reaction_type: QuestionReaction.reaction_types["downvote"]).count
    self.save
  end
end
