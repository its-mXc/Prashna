class QuestionTopic < ApplicationRecord
  belongs_to :question
  belongs_to :topic

  validates :question_id, uniqueness: {scope: :topic_id}
  #FIXME_AB: one topic for one question.
end
