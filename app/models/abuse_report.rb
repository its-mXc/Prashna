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
class AbuseReport < ApplicationRecord
  belongs_to :abuseable, polymorphic: true
  belongs_to :user

  validates :user_id, uniqueness: {scope: [:abuseable_id, :abuseable_type]}
  validate :ensure_not_reporting_own_abuseable

  after_save :check_should_abusable_be_unpublished

  private def check_should_abusable_be_unpublished
    if abuseable.abuse_reports.size >= ENV["abuse_reports_unpublish_no"].to_i
      abuseable.mark_abusive!
    end
  end

  private def ensure_not_reporting_own_abuseable
    if abuseable.user == user
      errors.add(:base, "Cannot report your own content")
      throw :abort
    end
  end
end
