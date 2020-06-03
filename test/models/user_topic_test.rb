# == Schema Information
#
# Table name: user_topics
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  topic_id   :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class UserTopicTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
