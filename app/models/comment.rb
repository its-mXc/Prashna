class Comment < ApplicationRecord
  include ReactionRecorder
  include Posted

  validate :parent_question_is_published
  validates :body, presence: true
  validates_length_of :words_in_comment, minimum: ENV["comment_word_length"].to_i

  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable
  has_many :notifications, as: :notificable
  belongs_to :commentable, polymorphic: true
  has_many :reactions, as: :reactable, dependent: :restrict_with_error
  has_many :abuse_reports, as: :abuseable

  after_save :generate_notifications
  after_save :unpublish_if_marked_abusive

  scope :published, -> { where(published: true) }


  def refresh_votes!
    self.reaction_count = reactions.upvotes.count -  reactions.downvotes.count
    save!
  end

  #FIXME_AB: this may be needed in questions and answers. so make it a concern

  private def words_in_comment
    body.scan(/\w+/)
  end

  def generate_notifications
    unless commentable.user == user
      commentable.user.notifications.create(notificable: self)
    end
  end

  private def parent_question_is_published
    if question.draft?
      errors.add(:base, 'Question is not published')
      throw :abort
    end
  end

  def mark_abusive!
    self.marked_abused = true
    save!
  end

  def reported_by?(user)
    abuse_reports.find_by(user: user)
  end

  private def unpublish_if_marked_abusive
    if self.marked_abused
      self.published = false
      self.save
    end
  end
end
