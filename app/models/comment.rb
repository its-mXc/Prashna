class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable

  validates :body, presence: true
  validates_length_of :words_in_comment, minimum: ENV["comment_word_length"].to_i

  #FIXME_AB: Also add a validation that if comment is being created on a question that question should be published.

  #FIXME_AB: should be private method
  private def words_in_comment
    body.scan(/\w+/)
  end
end
