class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable

  #FIXME_AB: add validations
  #FIXME_AB: should also belongs to user
end
