# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  body             :text(65535)
#  commentable_type :string(255)      not null
#  commentable_id   :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :bigint           not null
#  question_id      :bigint           not null
#  reaction_count   :integer          default(0)
#  published        :boolean          default(TRUE)
#  marked_abused    :boolean          default(FALSE)
#
require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
