class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :question

  #FIXME_AB: what if question is published then unpublished and then again published, lets remove
  validates :user_id, uniqueness: {scope: :question_id}

  scope :not_viewed, -> {where(viewed: false)}
  #FIXME_AB: also make another scope of viewed
end
