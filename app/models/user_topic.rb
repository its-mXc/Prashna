class UserTopic < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  #FIXME_AB: should be other way around. validates topic_id, scope user_id
  validates :user_id, uniqueness: {scope: :topic_id}
end
