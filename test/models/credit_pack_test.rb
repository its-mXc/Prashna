# == Schema Information
#
# Table name: credit_packs
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  price      :integer
#  credits    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class CreditPackTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
