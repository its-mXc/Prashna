# == Schema Information
#
# Table name: notifications
#
#  id               :bigint           not null, primary key
#  user_id          :bigint           not null
#  viewed           :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  notificable_type :string(255)
#  notificable_id   :bigint
#
require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
