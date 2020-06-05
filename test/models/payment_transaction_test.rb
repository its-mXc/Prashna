# == Schema Information
#
# Table name: payment_transactions
#
#  id             :bigint           not null, primary key
#  user_id        :bigint           not null
#  credit_pack_id :bigint           not null
#  status         :string(255)
#  card_token     :string(255)
#  response       :json
#  paid           :boolean          default(FALSE)
#  price          :integer
#  credits        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'test_helper'

class PaymentTransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
