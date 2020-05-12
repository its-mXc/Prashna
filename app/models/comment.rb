class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_many :comments, as: :commentable

  validates :body, presence: true
  #FIXME_AB: add another validation that body of a comment should have min x words.
end
