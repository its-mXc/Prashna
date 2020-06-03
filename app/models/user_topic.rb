# == Schema Information
#
# Table name: user_topics
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  topic_id   :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UserTopic < ApplicationRecord
  validates :topic_id, uniqueness: {scope: :user_id}

  belongs_to :user
  belongs_to :topic
end
