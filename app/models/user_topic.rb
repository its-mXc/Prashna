class UserTopic < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  validates :topic_id, uniqueness: {scope: :user_id}
end
