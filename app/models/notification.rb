class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :question

  #FIXME_AB: what if question is published then unpublished and then again published, lets remove
  # validates :user_id, uniqueness: {scope: :question_id}

  scope :not_viewed, -> {where(viewed: false)}
  scope :viewed, -> {where(viewed: true)}
  #FIXME_AB: also make another scope of viewed

  def mark_viewed!
    self.viewed = true
    save
    return !errors.any?
  end
end
