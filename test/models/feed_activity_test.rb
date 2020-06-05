# == Schema Information
#
# Table name: feed_activities
#
#  id         :bigint           not null, primary key
#  ip         :string(255)
#  url        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class FeedActivityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
