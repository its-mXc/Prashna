class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :question
  
  validates :user_id, uniqueness: {scope: :question_id}
  scope :not_viewed, -> {where(viewed: false)}
end
