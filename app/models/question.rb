class Question < ApplicationRecord
  extend ActiveModel::Callbacks

  enum status: { draft: 0, published: 1 }

  define_model_callbacks :mark_published, only: :before
  define_model_callbacks :mark_published, only: :after

  validates :title, uniqueness: { case_sensitive: true }
  validates :content, presence: true
  validates :content, length:{ minimum: ENV["minimum_question_char_length"].to_i, maximum: ENV["maximum_question_char_length"].to_i }



  belongs_to :user
  has_one_attached :pdf_file
  has_many :question_topics, dependent: :destroy
  has_many :topics, through: :question_topics
  has_many :reactions, as: :reactable, dependent: :restrict_with_error
  has_many :comments, as: :commentable, dependent: :restrict_with_error

  before_mark_published :has_needed_credit_balance
  before_mark_published :create_question_transaction
  after_mark_published :generate_url_slug
  after_save :generate_notifications, if: -> { self.published? }




  def generate_url_slug
    self.url_slug = title.downcase.gsub(REGEXP[:special_characters], "-")
    question_with_same_url_slug = self.class.find_by_url_slug(self.url_slug)
    if question_with_same_url_slug && question_with_same_url_slug != self
      self.url_slug = self.url_slug + rand(100).to_s
    end
    save
  end

  def to_param
    if self.published?
      url_slug
    else
      id
    end
  end

  private def create_question_transaction
    if user.credit_transactions.create(amount: ENV['question_post_debit'].to_i, transaction_type: CreditTransaction.transaction_types["debit"])
    else
      throw :abort
    end
  end

  #FIXME_AB: should be private. check other methods too.
  def generate_notifications
    self.topics.map(&:users).flatten.uniq.reject { |user| user.id == self.user.id }.each do |user|
        user.notifications.create(question: self)
    end
  end

  def interacted?
    # done like this to see code coverage when we write test
    if self.reactions.any?
      return true
    end

    if self.comments.any?
      return true
    end

    return false
  end

  def topic_names
    self.topics.pluck(:name)
  end

  def refresh_votes!
    self.reaction_count = reactions.upvotes.count -  reactions.downvotes.count
    save!
  end

  def mark_published!
    run_callbacks :mark_published do
      self.status = self.class.statuses["published"]
      save
    end
  end

  def has_needed_credit_balance
    unless user.credit_balance >= ENV['question_post_debit'].to_i
      #FIXME_AB: tell user how much balance needed
      errors.add(:base, "Not sufficient balance")
      throw :abort
    end
  end

  def editable?
    !interacted?
  end

  def record_reaction(reaction_type, user)
    question_reaction = reactions.find_by(user: user)
    if question_reaction
      question_reaction.reaction_type = Reaction.reaction_types[reaction_type]
      question_reaction.save
    else
      reactions.create(user: user, reaction_type: Reaction.reaction_types[reaction_type])
    end
  end
end
