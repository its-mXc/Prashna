class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notificable, polymorphic: true

  scope :not_viewed, -> {where(viewed: false)}
  scope :viewed, -> {where(viewed: true)}

  def mark_viewed!
    self.viewed = true
    save!
  end  
end
