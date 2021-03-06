# == Schema Information
#
# Table name: user_follows
#
#  id          :bigint           not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class UserFollow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validates :followed_id, uniqueness: {scope: :follower_id}
  validates :follower_id, uniqueness: {scope: :followed_id}

  #FIXME_AB: two uniqueness validations

  validate :not_following_self

  private def not_following_self
    if followed == follower
      errors.add(:base, 'Cannot follow self')
      throw :abort
    end
  end
end
