class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_many :comments, as: :commentable

  validates :body, presence: true
  validates_length_of :words_in_comment, minimum: ENV["comment_word_length"].to_i
  #FIXME_AB: add another validation that body of a comment should have min x words.

  def words_in_comment
    body.scan(/\w+/)
  end
end
