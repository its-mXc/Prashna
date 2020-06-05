# == Schema Information
#
# Table name: credit_transactions
#
#  id                :bigint           not null, primary key
#  user_id           :bigint           not null
#  amount            :integer
#  transaction_type  :integer
#  credit_balance    :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  transactable_type :string(255)
#  transactable_id   :bigint
#
require 'test_helper'

class CreditTransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
