class QuestionTopic < ApplicationRecord
  validates :question_id, uniqueness: {scope: :topic_id}

  belongs_to :question
  belongs_to :topic

end
