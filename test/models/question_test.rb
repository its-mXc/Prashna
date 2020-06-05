# == Schema Information
#
# Table name: questions
#
#  id             :bigint           not null, primary key
#  user_id        :bigint
#  title          :string(255)
#  content        :text(65535)
#  url_slug       :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  status         :integer
#  reaction_count :integer          default(0)
#  published_at   :datetime
#  marked_abused  :boolean          default(FALSE)
#
require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
