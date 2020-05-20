class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notificable, polymorphic: true

  scope :not_viewed, -> {where(viewed: false)}
  scope :viewed, -> {where(viewed: true)}

  def mark_viewed!
    self.viewed = true
    save!
  end

  def as_json(options={})
    if self.notificable_type == "Question"
      self.serializable_hash(include: [notificable: {include: [user: {only: [:name]}]} ])
    else
      self.serializable_hash(include: [notificable: {include: [:commentable, user: {only: [:name]}]} ])
    end
  end  
end
