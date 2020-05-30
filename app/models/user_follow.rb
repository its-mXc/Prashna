class UserFollow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true
  validates :followed_id, presence: true

  validate :not_following_self

  private def not_following_self
    if followed == follower
      errors.add(:base, 'Cannot follow self')
      throw :abort
    end
  end
end
