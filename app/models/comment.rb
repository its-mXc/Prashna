# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  body             :text(65535)
#  commentable_type :string(255)      not null
#  commentable_id   :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :bigint           not null
#  question_id      :bigint           not null
#  reaction_count   :integer          default(0)
#  published        :boolean          default(TRUE)
#  marked_abused    :boolean          default(FALSE)
#
class Comment < ApplicationRecord
  include ReactionRecorder
  include Posted
  include Reported

  validate :parent_question_is_published
  validates :body, presence: true

  #FIXME_AB: use new syntax
  validates :words_in_comment ,length: { minimum: ENV["comment_word_length"].to_i }
  validate :not_published_if_marked_abusive

  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable
  has_many :notifications, as: :notificable
  belongs_to :commentable, polymorphic: true
  has_many :reactions, as: :reactable, dependent: :restrict_with_error
  has_many :abuse_reports, as: :abuseable

  after_save :generate_notifications

  default_scope { where(published: true) }


  def refresh_votes!
    self.reaction_count = reactions.upvotes.count -  reactions.downvotes.count
    save!
  end

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
    unpublish!
  end
  
  def unpublish!
    self.published = false
    delete_notifications
    save!
  end

  def delete_notifications
    Notification.where(notificable: self).destroy_all
  end

  private def not_published_if_marked_abusive
    if marked_abused && published
      errors.add(:base, 'Cannot be published marked abused')
      throw :abort
    end
  end
end
