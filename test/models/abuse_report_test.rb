# == Schema Information
#
# Table name: abuse_reports
#
#  id             :bigint           not null, primary key
#  abuseable_type :string(255)
#  abuseable_id   :bigint
#  user_id        :bigint           not null
#  details        :text(65535)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'test_helper'

class AbuseReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
