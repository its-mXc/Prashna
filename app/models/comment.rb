class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_many :comments, as: :commentable

  validates :body, presence: true
  #FIXME_AB: add validations
  #FIXME_AB: should also belongs to user
end
