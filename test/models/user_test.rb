# == Schema Information
#
# Table name: users
#
#  id                       :bigint           not null, primary key
#  name                     :string(255)
#  password_digest          :string(255)
#  email                    :string(255)
#  user_type                :integer          default("user")
#  credit_balance           :integer          default(0)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  verified_at              :datetime
#  confirmation_token       :string(255)
#  password_reset_token     :string(255)
#  password_token_expire_at :datetime
#  auth_token               :string(255)
#  stripe_id                :string(255)
#  disabled                 :boolean          default(FALSE)
#
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
