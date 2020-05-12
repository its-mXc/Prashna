class QuestionTopic < ApplicationRecord
  belongs_to :question
  belongs_to :topic

  #FIXME_AB: one topic for one question.
end
