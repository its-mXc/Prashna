class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :question
  
  scope :not_viewed, -> {where(viewed: false)}
end
