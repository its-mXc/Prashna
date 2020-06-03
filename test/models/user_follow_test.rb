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
require 'test_helper'

class UserFollowTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
