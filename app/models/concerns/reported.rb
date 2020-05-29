module Reported
  extend ActiveSupport::Concern

  def reported_by?(user)
    abuse_reports.find_by(user: user)
  end
end