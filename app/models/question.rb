# == Schema Information
#
# Table name: questions
#
#  id             :bigint           not null, primary key
#  user_id        :bigint
#  title          :string(255)
#  content        :text(65535)
#  url_slug       :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  status         :integer
#  reaction_count :integer          default(0)
#  published_at   :datetime
#  marked_abused  :boolean          default(FALSE)
#
class Question < ApplicationRecord
  include ReactionRecorder
  include Posted
  include Reported
  include BasicPresenter::Concern
  extend ActiveModel::Callbacks

  enum status: { draft: 0, published: 1, unpublished: 2 }

  define_model_callbacks :mark_published, only: :before
  define_model_callbacks :mark_published, only: :after

  validates :title, presence: true
  validates :title, uniqueness: { case_sensitive: true }
  validates :content, presence: true
  validates :content, length:{ minimum: ENV["minimum_question_char_length"].to_i, maximum: ENV["maximum_question_char_length"].to_i }, unless: -> {self.content.blank?}
  validates :topics, presence: true

  belongs_to :user
  has_one_attached :file
  has_many :question_topics, dependent: :destroy
  has_one :credit_transaction, as: :transactable
  has_many :topics, through: :question_topics
  has_many :reactions, as: :reactable, dependent: :restrict_with_error
  has_many :comments, as: :commentable, dependent: :restrict_with_error
  has_many :root_comments, class_name: 'Comment', dependent: :restrict_with_error
  has_many :answers, dependent: :restrict_with_error
  has_many :abuse_reports, as: :abuseable

  before_mark_published :has_needed_credit_balance
  before_mark_published :not_published_if_marked_abusive
  before_mark_published :create_question_transaction
  after_mark_published :generate_url_slug
  after_mark_published :generate_notifications

  scope :recent, -> { order(published_at: :desc) }
  scope :by_users, ->(users) { where(user: users) }
  scope :in_last, ->(time) { where("published_at >= ?", time.ago) }

  def self.search(term)
    (published.where("title LIKE ?","%#{term}%") + Topic.search(term).map {|topic| topic.questions.published }.flatten).uniq
  end

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
    if user.credit_transactions.create(amount: -ENV['question_post_debit'].to_i, transaction_type: CreditTransaction.transaction_types["debit"], transactable: self)
    else
      throw :abort
    end
  end

  def generate_notifications
    self.topics.map(&:users).flatten.uniq.reject { |user| user.id == self.user.id }.each do |user|
        user.notifications.create(notificable: self)
    end
  end

  def interacted?
    # done like this to see code coverage when we write test
    if self.reactions.any?
      return true
    end

    if self.answers.any?
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
      self.published_at = Time.current
      save!
    end
  end

  def has_needed_credit_balance
    unless user.credit_balance >= ENV['question_post_debit'].to_i
      errors.add(:base, "Not sufficient balance, need atleast #{ENV['question_post_debit']} credits")
      throw :abort
    end
  end

  def editable?
    !interacted?
  end

  def answered_by_user?(user)
    return !!answers.unscoped.find_by(user_id: user.id)
  end

  def mark_abusive!
    #FIXME_AB: should be in single transaction
    self.marked_abused = true
    unpublish!
  end

  def unpublish!
    self.status = self.class.statuses["unpublished"]
    credit_transaction.reverse_transaction
    delete_notification
    save!
  end

  def delete_notification
    Notification.where(notificable: self).destroy_all
  end

  private def not_published_if_marked_abusive
    if marked_abused && published?
      errors.add(:base, 'Cannot be published marked abused')
      throw :abort
    end
  end

end
