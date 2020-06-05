# == Schema Information
#
# Table name: question_topics
#
#  id          :bigint           not null, primary key
#  question_id :bigint           not null
#  topic_id    :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class QuestionTopic < ApplicationRecord
  validates :question_id, uniqueness: {scope: :topic_id}

  belongs_to :question
  belongs_to :topic

end
